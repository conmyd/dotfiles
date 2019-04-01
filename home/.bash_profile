if [[ -f ~/settings.sh ]]; then
	source ~/settings.sh
fi

for bashfile in `ls --ignore '.*~' -A ~/bash/`
do
	source ~/bash/$bashfile
done

echo "(OK) .bash_profile"
