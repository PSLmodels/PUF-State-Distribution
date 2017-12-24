#!/bin/bash
# Don Boyd 6/16/2017

# UPDATE: MAKE SURE IT IS A 64-BIT BUILD!!!

# Read documentation below before running.

# 1. Start Msys2 shell as administrator - use the Mingw-w64 64 bit button
# 2. cd to the scripts director
# 3. bash <scriptname.sh>

# !! NOTE !! mumps_mpi.h was not in the Mumps I downloaded today 6/15/2017. I think a patch was supposed to create it, but it did not happen?!
# So I copied it from an old Mumps directory.


####################################################################################################
#                  Define directory locations
####################################################################################################
SVN_DIR=C:/PROGRA~1/TortoiseSVN/bin              # directory where the subversion svn.exe program is located - MUST EXIST
R_HOME=C:/PROGRA~1/R/R-34~1.0PA                  # directory where R bin is located, for Rblas and Rlapack - MUST EXIST (C:\Program Files\R\R-3.4.0patched\bin\x64)

R_ARCH="x64"                                     # directory we will create, named after 62-bit or 32-bit R architecture we are building for (either or "x64" "i386") but can be named whatever you want

# Assemble the name of the directory into which we will compile Ipopt, which I call PLACE
IPOPT_MAIN=C:/Ipopt2017/IpoptHSL/Ipopt                 # MUST EXIST ALREADY
IPOPT_VER=3.12                                   # MUST EXIST ALREADY. Name of Ipopt version to download and use. We will download files into here.

BLD_NAME=build.par64                               # the subdirectory under the version directory, where the build will go; - DIRECTORY DOES NOT HAVE TO EXIST

IPOPT_DIR=${IPOPT_MAIN}/${IPOPT_VER}             # for a clean install from scratch, delete this directory
BLD_DIR=${IPOPT_DIR}/${BLD_NAME}
PLACE=${BLD_DIR}/${R_ARCH}                       # This is where the build will go

#  Get source code if needed - see functions way below

####################################################################################################
#                  Functions for getting source code -- MUST MODIFY
###################################################################################################
function getIpopt {
  echo "Getting IPOPT source..."
  cd $IPOPT_MAIN # does NOT have the version number -- version directory will be created
  $SVN_DIR/svn co https://projects.coin-or.org/svn/Ipopt/stable/$IPOPT_VER
}

function getBLAS {
  # get inefficient netlib BLAS
  # or use another function to get optimized BLAS
  echo "Get BLAS..."
  cd ${IPOPT_DIR}/ThirdParty/Blas
  ./get.Blas    # get inefficient BLAS from www.netlib.org
}

function getLAPACK {
  echo "Get LAPACK..."
  cd ${IPOPT_DIR}/ThirdParty/Lapack
  ./get.Lapack    # get inefficient LAPACK from www.netlib.org
}

function getMUMPS {
  # This looks for MUMPS version 4.10.0 
  # BEFORE USING, MUST VERIFY VERSION NUMBER THAT IS AVAILABLE. I DID SO on 8/30/2012
  # at following url, and it was correct then
  # http://graal.ens-lyon.fr/MUMPS/index.php?page=dwnld
  echo "Get MUMPS..."
  cd $IPOPT_DIR/ThirdParty/Mumps
  ./get.Mumps   # get the Mumps linear solver for symmetric indefinite matrices
}

function getMetis { 
  # This looks for Metis version 4.0.3 at http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz
  # newer versions are here: http://glaros.dtc.umn.edu/gkhome/metis/metis/download but IPOPT does not use (?)
  echo "Get Metis..."
  cd $IPOPT_DIR/ThirdParty/Metis
  ./get.Metis   # get Metis, which makes Mumps work better
}


####################################################################################################
#                  Get source code if needed
###################################################################################################
#getIpopt
#getBLAS
#getLAPACK
#getMUMPS
#getMetis
#exit


####################################################################################################
#                  Put HSL code in place
###################################################################################################
# AFTER getting source codes, per above, unzip the HSL code (I am now using the updated release candidate
# code in coinhsl-2015.06.23.tar.gz) into its own subdirectory of HSL and rename it "coinhsl"
# so that the directory structure looks like:

#      <C:\Ipopt2017\IpoptHSL>\3.12\ThirdParty\HSL\coinhsl


####################################################################################################
#                  Prepare directories
####################################################################################################

# CAUTION: Remove old directories and files if build from scratch is desired
# rm -rf ${BLD_DIR} 
# END CAUTION

echo "Creating directories... If directories already exist, will throw error, but that's ok"
mkdir ${BLD_DIR}; mkdir ${BLD_DIR}/${R_ARCH}
PLACE=${BLD_DIR}/${R_ARCH}
cd ${PLACE}

####################################################################################################
#                  Configure, make, install
####################################################################################################

export PATH=/c/Rtools/mingw_64/bin:$PATH       # CRITICAL tell the system the location of the 64-bit MinGW compilers used by Rtools THIS IS CRITICAL!!!

# Now configure
#../../configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --prefix="${BLD_DIR}/${R_ARCH}" --enable-static --disable-shared LDFLAGS="-LC:/PROGRA~1/R/R-34~1.0PA/bin/x64 -Wl,-lRblas -Wl,-lRlapack" ADD_CFLAGS=-fopenmp ADD_FFLAGS=-fopenmp ADD_CXXFLAGS=-fopenmp
# NOTE: Remove:   ADD_CFLAGS=-fopenmp ADD_FFLAGS=-fopenmp ADD_CXXFLAGS=-fopenmp   if you don't want HSL parallel
#exit

# make 
#make test
make install

# exit



####################################################################################################
#                  After make install, copy files
####################################################################################################

#  1) Copy Makevars.win to the proper directory
# Finally, per ipoptr (not ipopt) documentation:
#   copy       Makevars.win
#   from       ${BLD_DIR}/${R_ARCH}/Ipopt/contrib/RInterface/src
#   to         $IPOPT_DIR/Ipopt/contrib/RInterface/src

#  2) OPTIONALLY copy faster version of make.sparse to the proper directory
# From: C:/Ipopt/BackupCode/make.sparseDJB.R
# To: C:/Ipopt/3.12/Ipopt/contrib/RInterface/R/make.sparse.R


cp ${BLD_DIR}/${R_ARCH}/Ipopt/contrib/RInterface/src/Makevars.win  $IPOPT_DIR/Ipopt/contrib/RInterface/src/Makevars.win
cp C:/Ipopt2017/BackupCode/make.sparseDJB.R  $IPOPT_DIR/Ipopt/contrib/RInterface/R/make.sparse.R

echo "ALL DONE WITH BASH! DO REMAINING STEPS AND THEN INSTALL ipoptr FROM WITHIN R"
exit




####################################################################################################
#                  All done
####################################################################################################
exit # Everything below is documentation


####################################################################################################
#                  Critical steps
####################################################################################################
1. Installing Msys2.0 (http://www.msys2.org/) rather than Msys1.0, at Tony Kelman's suggestion. It is a better environment than 1.0.

2. Making sure that I clearly defined which compilers to use. I included the following line in my bash script:
export PATH=/c/Rtools/mingw_64/bin:$PATH  

3. Including precise linker flags. There were two issues:
a) The HSL documentation said a Blas library must be provided but did not say a Lapack library must be provided. However, it turned out that I needed both.
b) My computer was not finding the lapack library during the make step. Tony Kellman advised me to put "-Wl," before the name of the blas and lapack libraries, and that solved an endless stream of problems. the EXACT syntax is important -- it was dash/upper-case-W/lower-case-letter-l/comma with no spaces. 

Here are the linker flags I used.

LDFLAGS="-LC:/PROGRA~1/R/R-34~1.0PA/bin/x64 -Wl,-lRblas -Wl,-lRlapack" 

My whole configure statement was:

../../configure --prefix="${BLD_DIR}/${R_ARCH}" --enable-static --disable-shared LDFLAGS="-LC:/PROGRA~1/R/R-34~1.0PA/bin/x64 -Wl,-lRblas -Wl,-lRlapack" ADD_CFLAGS=-fopenmp ADD_FFLAGS=-fopenmp ADD_CXXFLAGS=-fopenmp

If you don't want to allow HSL solvers to run in parallel, you can remove:

 ADD_CFLAGS=-fopenmp ADD_FFLAGS=-fopenmp ADD_CXXFLAGS=-fopenmp


####################################################################################################
#                  Documentation
####################################################################################################

How a novice installed Ipopt for Windows 10 64-bit, with HSL linear solvers, for use with R interface Ipoptr.

I was only able to accomplish this after help from Tony Kellman and Stefan Vigerske who are Ipopt developers and maintainers, and, early on, from the author of ipoptr, Jelmer Ypma.

0. GOALS
 Compile Ipopt for Windows 10 64-bit, in a manner that will allow it to be called from R.
 Include HSL linear solvers, in addition to Mumps. Ideally allow them to run in parallel.
 Compile with the same MinGW compilers that are used to compile Ipoptr. These are the Rtools compilers that were already installed on my system. (I am not SURE this is essential.)
 Compile with the Blas and Lapack dll libraries included with R, to avoid any possible conflict among versions. (I am not SURE this is essential.)
 Doing this caused many hours of frustration so I have documented my steps below. There is no guarantee that they will work for others but they did work for me.

 I. Steps PRIOR to running script:

..A. Clean the environment. I did this to be SURE I was not going to have legacy compilers and other software interfering with the build. I got rid of old msys1.0, and several old MinGW compilers. I deleted their directories from the path. I use the free Rapid Environment Editor (https://www.rapidee.com) to edit the path variable because I am afraid to mess with it through Windows. More-experienced users might not have to delete all of these things, if they are sure they can keep them from accidentally being used.

..B. Set up Msys2.0 to create an environment for running bash scripts
....1. Download from http://www.msys2.org/. I used msys2-x86_64-20161025.exe. I did NOT download any compilers because I just wanted the Msys2.0 environment and planned to use the MinGW compilers I already had in Rtools.
....2. Install Msys2.0, following directions at  http://www.msys2.org/, which involved a few "pacman" commands after installation.
....3. Additional installation: I had to add make.exe with the following command:
       pacman -S make

.. C. Per the HSL readme, extract the code provided under academic license (coinhsl-2014.01.10.zip) to a directory, rename that directory to coinhsl, and include that directory under the already-existing Ipopt Third Party directory:

 <ipopt>/3.12/ThirdParty/HSL

so that we have:

<ipopt>/3.12/ThirdParty/HSL/coinhsl

..D. Get source code as needed

II. AFTER running script






III. Miscellaneous tools and diagnostics
where make                                      # run this from a bash prompt to see which "make.exe" the system is using
which gcc                                       # run this from a bash prompt to see which gcc 
gcc -v                   # verbose -- tells about the compilers
./configure --help    # from within the directory of a pre-made configure file, to learn of options


####################################################################################################
#                  configure --help from HSL
####################################################################################################
$ ./configure --help
`configure' configures coinhsl 2014.01.10 to adapt to many kinds of systems.

Usage: ./configure [OPTION]... [VAR=VALUE]...

To assign environment variables (e.g., CC, CFLAGS...), specify them as
VAR=VALUE.  See below for descriptions of some of the useful variables.

Defaults for the options are specified in brackets.

Configuration:
  -h, --help              display this help and exit
      --help=short        display options specific to this package
      --help=recursive    display the short help of all the included packages
  -V, --version           display version information and exit
  -q, --quiet, --silent   do not print `checking ...' messages
      --cache-file=FILE   cache test results in FILE [disabled]
  -C, --config-cache      alias for `--cache-file=config.cache'
  -n, --no-create         do not create output files
      --srcdir=DIR        find the sources in DIR [configure dir or `..']

Installation directories:
  --prefix=PREFIX         install architecture-independent files in PREFIX
                          [/usr/local]
  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
                          [PREFIX]

By default, `make install' will install all the files in
`/usr/local/bin', `/usr/local/lib' etc.  You can specify
an installation prefix other than `/usr/local' using `--prefix',
for instance `--prefix=$HOME'.

For better control, use the options below.

Fine tuning of the installation directories:
  --bindir=DIR            user executables [EPREFIX/bin]
  --sbindir=DIR           system admin executables [EPREFIX/sbin]
  --libexecdir=DIR        program executables [EPREFIX/libexec]
  --sysconfdir=DIR        read-only single-machine data [PREFIX/etc]
  --sharedstatedir=DIR    modifiable architecture-independent data [PREFIX/com]
  --localstatedir=DIR     modifiable single-machine data [PREFIX/var]
  --libdir=DIR            object code libraries [EPREFIX/lib]
  --includedir=DIR        C header files [PREFIX/include]
  --oldincludedir=DIR     C header files for non-gcc [/usr/include]
  --datarootdir=DIR       read-only arch.-independent data root [PREFIX/share]
  --datadir=DIR           read-only architecture-independent data [DATAROOTDIR]
  --infodir=DIR           info documentation [DATAROOTDIR/info]
  --localedir=DIR         locale-dependent data [DATAROOTDIR/locale]
  --mandir=DIR            man documentation [DATAROOTDIR/man]
  --docdir=DIR            documentation root [DATAROOTDIR/doc/coinhsl]
  --htmldir=DIR           html documentation [DOCDIR]
  --dvidir=DIR            dvi documentation [DOCDIR]
  --pdfdir=DIR            pdf documentation [DOCDIR]
  --psdir=DIR             ps documentation [DOCDIR]

Program names:
  --program-prefix=PREFIX            prepend PREFIX to installed program names
  --program-suffix=SUFFIX            append SUFFIX to installed program names
  --program-transform-name=PROGRAM   run sed PROGRAM on installed program names

System types:
  --build=BUILD     configure for building on BUILD [guessed]
  --host=HOST       cross-compile to build programs to run on HOST [BUILD]

Optional Features:
  --disable-option-checking  ignore unrecognized --enable/--with options
  --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
  --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
  --disable-dependency-tracking  speeds up one-time build
  --enable-dependency-tracking   do not reject slow dependency extractors
  --enable-shared[=PKGS]  build shared libraries [default=yes]
  --enable-static[=PKGS]  build static libraries [default=yes]
  --enable-fast-install[=PKGS]
                          optimize for fast installation [default=yes]
  --disable-libtool-lock  avoid locking (might break parallel builds)

Optional Packages:
  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
  --with-pic[=PKGS]       try to use only PIC/non-PIC objects [default=use
                          both]
  --with-gnu-ld           assume the C compiler uses GNU ld [default=no]
  --with-sysroot=DIR Search for dependent libraries within DIR
                        (or the compiler's sysroot if not specified).
  --with-blas=<lib>       use BLAS library <lib>

Some influential environment variables:
  FC          Fortran compiler command
  FCFLAGS     Fortran compiler flags
  LDFLAGS     linker flags, e.g. -L<lib dir> if you have libraries in a
              nonstandard directory <lib dir>
  LIBS        libraries to pass to the linker, e.g. -l<library>
  F77         Fortran 77 compiler command
  FFLAGS      Fortran 77 compiler flags
  CC          C compiler command
  CFLAGS      C compiler flags
  CPPFLAGS    (Objective) C/C++ preprocessor flags, e.g. -I<include dir> if
              you have headers in a nonstandard directory <include dir>
  CPP         C preprocessor

Use these variables to override the choices made by `configure' or to help
it to find libraries and programs with nonstandard names/locations.

Report bugs to <hsl@stfc.ac.uk>.

