#!/bin/bash


# Remerge es un fron-end bash para quitarme el tedio de hacer update y otras tareas
# com emerge de Gentoo / Funtoo
function init_remerge() {

    if [ "$1" == "update" ]; then
        sync_emerge
        mount_exec_var
        update_emerge
        mount_noexec_var
        exit 0
    elif [ "$1" == "install" ]; then
        mount_exec_var
        install_emerge $2
        mount_noexec_var
        exit 0
    elif [ "$1" == "revdep" ]; then
        revdep
        exit 0
    else
        echo "Indique alguna opción. Opciones validas: update o install <packages>"
        exit 0
    fi
}

# Funcion de montaje exec para /var
function mount_exec_var() {
    sudo mount -o remount,exec /var
}

# Funcion para montaje noexec para /var
function mount_noexec_var(){
    sudo mount -o remount /var
}

function sync_emerge() {
    sudo layman -s ALL
    sudo emerge --sync
}

# Funcion de actualizacion del sistema
function update_emerge(){
    echo "Ejecutando actualización del sistema. Espere..."
    sudo emerge -avuDN --with-bdeps=y --newuse @world
}

# Funcion de instalacion de paquetes
function install_emerge(){
    echo "Ejecutando instalación de los paquetes: " $1
    sudo emerge -av $1
}

# Funcion para revdep-rebuild
function revdep() {
    echo "Revisando dependencias y librerias rotas en el sistema..."
    sudo revdep-rebuild -v -- --ask
}

# Comprobando permisos
# Primeros verificamos que el usuario tenga permisos de root
function is_root_user() {
    if [ "$USER" != "root" ]; then
        echo "Permiso denegado."
        echo "Este programa solo puede ser ejecutado por el usuario root"
        echo "Use sudo para poder garantizar permisos administrativos"
        exit
    else
        init_remerge $1 $2
    fi
}

# Llamada a la función de inicialización
is_root_user $1 $2
