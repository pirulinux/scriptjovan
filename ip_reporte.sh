#!/bin/bash
### BEGIN INIT INFO
# Provides: ip_reporte.sh
# Required-Start: mysql $remote_fs
# Required-Stop: mysql $remote_fs
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Manda ip a mysql y correo
# Description: Manda ip a mysql y correo
### END INIT INFO

ipanterior=""
while true ; do

ip=`ifconfig eth | grep -oiE '([0-9]{1,3}\.){3}[0-9]{1,3}' | grep -v 255`

##comienso del if
if [ $ip=!$ipanterior ]; then
##comienso del if

$ipanterior=$ip
##comienso del if

consulta="UPDATE magento.core_config_data SET value = 'http://$ip/' WHERE core_config_data.config_id =7;"
dia=`date +%d`;
mes=`date +%m`;
year=`date +%Y`;
FECHA=$dia-$mes-$year;
reporte=/root/Reportes/$FECHA.html
peso=`du -hls /home/magentotienda/`;
echo "-----------------------------------------";
echo
echo
echo " ACTUALIZANDO LA IP DEL EQUIPO ";
echo
echo
#mysql -u root -p magento -e $consulta;
mysql -h localhost -u root -pmageroot << END
use magento;
$consulta;
END
echo "Nueva ip : $ip";
echo
echo
echo "-----------------------------------------";
echo
echo
echo "-----------------------------------------";
echo
echo " ENVIANDO CORREO A USUARIO(S) ";
echo '<center><nav class="contenedor" style="position-absolute;top:100px; width:500px; height:300px; background:white; border-radius:15px;"><secctio class="contenedor2"><center><table style=" border:1px orange ridge; border-radius:15px; width: 400px; box-shadow: -6px -1px 8px rgba(0, 0, 0,0.80); -moz-box-shadow: -6px -1px 8px rgba(0, 0, 0, 0.80); -webkit-box-shadow: -6px -1px 8px rgba(0, 0, 0, 0.80);"><tr><td style="width:150px; height:30px"><img src="http://upload.wikimedia.org/wikipedia/commons/3/3e/Logo_Movilnet.JPG"></td><td><img src="http://enterprise.magento.com/sites/all/themes/mag_redesign/images/logos/logo-gl-footer.png"></td></tr><tr><td style="width:150px; height:30px">Dirección<td style="width:150px; height:30px"><b><a href="http://'$ip> $reporte
echo '/" title="Visitar magento "> '$ip >> $reporte
echo '</b></td></tr><tr><td colspan=2 style="width:150px; height:30px">Correo Enviado automaticamente desde servidor Magento Movilnet</td></tr></table></center></section></nav></center>'>> $reporte
mutt -s "Reporte mañana de $FECHA" principalcount2013@gmail.com < $reporte

#
#
#mutt -s "Reporte mañana de $FECHA" jcastr05@cantv.com.ve < $reporte
#mutt -s "Reporte mañana de $FECHA" racost01@cantv.com.ve < $reporte
#mutt -s "Reporte mañana de $FECHA" jquija03@cantv.com.ve < $reporte
#
#

echo " Correo enviado con exito. ";
echo "-----------------------------------------";
#//////////////////////////////////////////////////////////////////////////////
#fin del bucle infinito
#fin del if
fi
#fin del if

sleep 1m
#20m es el tiempo que tarda entre ejecuciones puedes usar 12h 12345s o como gustes

done

