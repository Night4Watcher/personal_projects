#!/bin/bash

# Variables generales de las que hace uso el programa
sleep_time=2
os_system=$OSTYPE

# Informamos al usuario de que comienza la instalacion de docker
echo "Vamos a comenzar la instalacion de Docker"
sleep $sleep_time

# Comprobamos el sistema operativo que esta siendo utilizado
if [ $os_system == "linux-gnu" ];
then
	# Cambiar directorio de trabajo a directorio del usuario
	cd
	# Comprobamos que distribucion de linux se esta utilizando
	distro=$(lsb_release -si)
	if [ $distro == "Fedora" ];
	then
		echo "El sistema operativo es fedora"
		sleep $sleep_time
		echo "Instalamos los plugins para el gestor de paquetes dnf"
		# Actualizamos los repositorios del sistema
		sudo dnf update
		# Instalamos los plugins para el gestor de paquetes dnf
		sudo dnf install dnf-plugins-core
		# Revisamos la version de fedora para añadir el repositorio de docker-ce
		clear
		echo "Añadimos el repositorio de docker-ce"
		distro_version=$(lsb_release -sr)
		if [ "$distro_version" -ge 43 ];
		then
			echo "Se realizara este proceso si el dispositivo tiene fedora 41 o superior"
			sudo dnf config-manager addrepo --from-repofile="https://download.docker.com/linux/fedora/docker-ce.repo"
		else
			echo "Se realiara este proceso si el dispositivo tiene fedora 40"
			sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
		fi
		echo "Ahora instalaremos lo necesario para que docker funcione"
		sudo dnf install docker-ce docker-ce-cli containerd.io
		clear
		echo "Instalacion finalizada, verifique que docker funciona correctamente"
		# Añadimos al usuario al grupo de docker
		sudo usermod -aG docker $USER
		echo "Deberias de reiniciar el dispositivo para poder usar docker sin sudo"   
	fi
else
	# Informamos al usuario de que no se ha detectado su distribucion de Linux
	echo "El sistema operativo no es una distribucion localizada por la aplicacion."
	sleep $sleep_time
fi
