#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Pi-hole
# Applies patches to Pi-hole
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly base=/var/www/html/admin
declare hostname

hostname="hassio"
if hass.api.supervisor.ping; then
    hostname=$(hass.api.host.info.hostname)
elif hass.file_exists '/data/hostname'; then
    hostname=$(</data/hostname)
fi

hass.log.debug 'Patching Pi-hole for use with Hass.io'
sed -i 's/Are you sure you want to send a poweroff command to your Pi-Hole\?/Are you sure you want to send a stop command to your Pi-Hole add-on\?/g' "${base}/scripts/pi-hole/js/settings.js"
sed -i 's/Are you sure you want to send a reboot command to your Pi-Hole\?/Are you sure you want to send a restart command to your Pi-Hole add-on\?/g' "${base}/scripts/pi-hole/js/settings.js"
sed -i 's/Designed For Raspberry Pi/Modified for Home Assistant/g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's/echo -ne/echo -e/g' /opt/pihole/gravity.sh
sed -i 's/Power off system/Stop add-on/g' "${base}/settings.php"
sed -i 's/Restart system/Restart add-on/g' "${base}/settings.php"
sed -i 's/The system will poweroff in 5 seconds.../The add-on will stop in 15 seconds.../g' "${base}/scripts/pi-hole/php/savesettings.php"
sed -i 's/The system will reboot in 5 seconds.../The add-on will restart in 15 seconds.../g' "${base}/scripts/pi-hole/php/savesettings.php"
sed -i 's/Updates/Forums/g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's/Yes, poweroff/Yes, stop/g' "${base}/scripts/pi-hole/js/settings.js"
sed -i 's/Yes, reboot/Yes, restart/g' "${base}/scripts/pi-hole/js/settings.js"
sed -i 's#/etc/hostname#/data/hostname#g' "${base}/settings.php"
sed -i 's/donate.gif/buymeacoffee.svg/g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's/Donate/Buy Me A Coffee!/g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's/Donate/Buy Me A Coffee!/g' "${base}/scripts/pi-hole/php/footer.php"
sed -i 's/fa-paypal/fa-coffee/g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's/fa-heart/fa-coffee/g' "${base}/scripts/pi-hole/php/footer.php"
sed -i 's#https://github.com/pi-hole/pi-hole/releases#https://community.home-assistant.io/t/repository-community-hass-io-add-ons/24705?u=frenck#g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's#https://github.com/pi-hole#https://github.com/hassio-addons/addon-pi-hole#g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's#https://pi-hole.net/donate#https://www.buymeacoffee.com/frenck#g' "${base}/scripts/pi-hole/php/footer.php"
sed -i 's#https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&amp;hosted_button_id=3J2L3Z4DHW9UY#https://www.buymeacoffee.com/frenck#g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's#https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3J2L3Z4DHW9UY#https://www.buymeacoffee.com/frenck#g' "${base}/scripts/pi-hole/php/header.php"
sed -i 's#sudo pihole -a poweroff#nohup bash -c \\"sudo /usr/bin/stop_addon\\" \&> /dev/null </dev/null \&#g' "${base}/scripts/pi-hole/php/savesettings.php"
sed -i 's#sudo pihole -a reboot#nohup bash -c \\"sudo /usr/bin/restart_addon\\" \&> /dev/null </dev/null \&#g' "${base}/scripts/pi-hole/php/savesettings.php"
sed -i "s/gethostname()/\"${hostname}\"/g" "${base}/scripts/pi-hole/php/header.php"
sed -i "s#\"localhost\"#\"localhost\",\"${hostname}\",\"${hostname}\.local\"#g" "${base}/scripts/pi-hole/php/auth.php"
sed -i 's#/etc/pihole/logrotate#/etc/logrotate.d/pihole#g' /opt/pihole/piholeLogFlush.sh
