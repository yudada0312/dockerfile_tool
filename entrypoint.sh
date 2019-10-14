#!/bin/bash
folder=/var/www/html/$1/public
if [ ! -d "$folder" ]; then
  echo "$folder not exist!"
  return
fi

cd $folder

chmod -R 777 storage/
chmod -R 777 bootstrap/cache
chmod 777 bootstrap/

#取代 php artisan storage:link # 圖片上傳套件需要建立軟連結(相對路徑)
ln -s ../storage/app/public storage
echo “create soft link - image“

#取代 php artisan theme:link # 為娛樂城佈景主題建立軟連結(相對路徑)
for entry in /var/www/html/$1/resources/views/casino/*
do
  dirname=$(basename "$entry")
  if [ $dirname = "__share__" ]
  then
    continue
  fi
  ln -s ../resources/views/casino/${dirname}/__assets__ theme-${dirname}
  echo “create soft link - ${dirname}“
done

#composer install

# npm install
# npm run dev

#tail -f /dev/null