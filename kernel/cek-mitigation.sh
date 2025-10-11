for f in /sys/devices/system/cpu/vulnerabilities/*; do
    echo "$(basename $f) : $(cat $f)"
done
