#!/bin/bash

cd /var/www/html/public

#取代 php artisan storage:link # 圖片上傳套件需要建立軟連結(相對路徑)
ln -s ../storage/app/public storage
echo “create soft link - image“

#取代 php artisan theme:link # 為娛樂城佈景主題建立軟連結(相對路徑)
for entry in /var/www/html/resources/views/casino/*
do
  dirname=$(basename "$entry")
  if [ $dirname = "__share__" ]
  then
    continue
  fi
  ln -s ../resources/views/casino/${dirname}/__assets__ theme-${dirname}
  echo “create soft link - ${dirname}“
done

cd /var/www/html
#composer install

# npm install
# npm run dev

#tail -f /dev/null