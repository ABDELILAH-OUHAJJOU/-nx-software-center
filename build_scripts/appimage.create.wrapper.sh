#!/usr/bin/env bash

echo ""
echo "Creating application wrapper"

DESKTOP_FILE=$(ls appdir/usr/share/applications/*.desktop | cut -f1)

if [[ -z ${DESKTOP_FILE} ]]; then
    echo "Unable to find a .desktop in appdir"
    echo ""
    exit 1;
fi

RUNNABLE=`cat ${DESKTOP_FILE} | grep Exec | cut -f2 -d=`

if [[ -z ${RUNNABLE} ]]; then
    echo "Unable to find a runnable in the appimage desktop file."
    echo ""
    exit 1;
fi

echo "Creating wrapper for ${RUNNABLE}"

WRAPPER_NAME="${RUNNABLE}_wrapper.sh"
WRAPPER_PATH=appdir/usr/bin/${WRAPPER_NAME}

# Create file
mkdir -p appdir/usr/bin/
touch ${WRAPPER_PATH}
chmod +x ${WRAPPER_PATH}

# Fill file
echo "#!/usr/bin/env bash" | tee ${WRAPPER_PATH}

echo "#FILE AUTO GENERATED BY APPIMAGE CREATE WRAPPER"  | tee -a ${WRAPPER_PATH}

echo "export LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:\${APPDIR}/usr/lib/" | tee -a ${WRAPPER_PATH}
echo "export XDG_CONFIG_DIRS=\${XDG_CONFIG_DIRS}:\${APPDIR}/etc/xdg/" | tee -a ${WRAPPER_PATH}
echo "export XDG_DATA_DIRS=\${XDG_DATA_DIRS}:\${APPDIR}/usr/share/" | tee -a ${WRAPPER_PATH}

echo "\${APPDIR}/usr/bin/${RUNNABLE}" | tee -a ${WRAPPER_PATH}

# Write appdir .desktop
DESKTOP_FILE_TARGET=appdir/`basename ${DESKTOP_FILE}`

cp ${DESKTOP_FILE} ${DESKTOP_FILE_TARGET}
sed -i "s/Exec=${RUNNABLE}/Exec=${WRAPPER_NAME}/g" ${DESKTOP_FILE_TARGET}

echo "Done"
echo ""