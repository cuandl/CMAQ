#! /bin/csh -f
set echo

#scom command defines compiler and libraries
#source ~/scom -d -c ifc

setenv COMPILER INTEL

#define path to mechanism include or module data files
 set mech_archive = /home/${USER}/CCTM_git_repository/MECHS
 set mechanism    = cb05e51_ae6_aq
 setenv suffix ikx
 setenv APPL ${mechanism}
#setenv GC_INC /home/${USER}/tools/mech_processor/output/cb05e6cl_ae6_aq
#setenv GC_INC ${mech_archive}/cb05tucl_ae6_aq
 setenv GC_INC ${mech_archive}/${mechanism}

#use RXNS_DATA_MODULE, comment out if not use
 setenv USE_RXNS_MODULES T
 
#Whether to include spectral values of refractive indices for aerosol species [T|Y|F|N]
setenv WVL_AE_REFRAC F

#whether optical and CSQY data written to two separate file
setenv SPLIT_OUTPUT F

#Variables used to name executable, i.e., CSQY_TABLE_PROCESSOR_mechanism
#setenv APPL   ${APPL}_${suffix}
 setenv APPL   ${APPL}

set BASE  = /home/${USER}/tools/CSQY_table_processor
set XBASE = /home/${USER}/tools/CSQY_table_processor
set EXEC  = CSQY_TABLE_PROCESSOR_${APPL}


#create executable
 cd BLD ; make clean; make -f dumb.makefile; cd ..

 set OUTDIR = ${BASE}/output/csqy_table_${APPL}-v3
#set OUTDIR = ${GC_INC}
if( ! ( -d $OUTDIR ) )mkdir -p $OUTDIR

#cp -f ${OUTDIR}"/PHOT_OPTICS_DATA"  ${BASE}/OPTICS_DATA 
#cp -f ${OUTDIR}/CSQY_DATA_*_aq ${BASE}/CSQY_DATA 

set CSQY_DIR    = ${BASE}/photolysis_CSQY_data
set REFRACT_DIR = ${BASE}/water_clouds
set WVBIN_DIR   = ${BASE}/flux_data

ln -s -f ${CSQY_DIR}  CSQY_DATA_RAW
ln -s -f $WVBIN_DIR/wavel-bins.dat  WVBIN_FILE
ln -s -f $WVBIN_DIR/solar-p05nm-UCI.dat  FLUX_FILE
ln -s -f $OUTDIR OUT_DIR

#define files for aerosol refractive index
ln -s -f $REFRACT_DIR/water_refractive_index.dat WATER
ln -s -f $REFRACT_DIR/inso00  INSOLUBLE
ln -s -f $REFRACT_DIR/inso00  DUST
ln -s -f $REFRACT_DIR/waso00 SOLUTE
#ln -s -f $REFRACT_DIR/soot00 SOOT
ln -s -f $REFRACT_DIR/soot00-two_way-Oct_21_2012 SOOT
ln -s -f $REFRACT_DIR/ssam00 SEASALT

# cd $OUTDIR

if( ! ( -e  ${XBASE}/${EXEC} ) )then
     \ls ${XBASE}/${EXEC}
     echo "make failed or value of XBASE incorrect"
     exit()
endif

 ${XBASE}/${EXEC}

 \rm -f CSQY_DATA_RAW
 \rm -f WVBIN_FILE
 \rm -f FLUX_FILE
 \rm -f OUT_DIR

 \rm -f  WATER
 \rm -f  INSOLUBLE
 \rm -f  SOLUTE
 \rm -f  SOOT
 \rm -f  SEASALT
 \rm -f  DUST
 \rm -f ${XBASE}/${EXEC}
 \rm -f fort.*
#\rm -f  OPTICS_DATA 
#\rm -f  CSQY_DATA 
 
 cd $BASE

\ls ${OUTDIR}

exit()
