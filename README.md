

To use:
- cp config/settings.sh.sample config/settings.sh
- Edit config/settings.sh
- Make backup of prestashop images
- Put on pub/media/import/ magento folder
- Execute script migrate-prestashop-magento.sh
- Import products from generated csv on Magento2
- Import products images from generated csv on Magento2
- Import categories from generated csv on Magento2


Requirements
- ssh access to mysql server
- export produtos images directory from prestashop folder img/p to magento pub/media/import/

   find . -regextype posix-awk -iregex '.*[0-9]+.jpg$|.*[0-9]+-small_default.jpg$' -exec cp -f {} images/ \;
   find . -regextype posix-awk -iregex '.*[0-9]+.jpg$|.*[0-9]+-small_default.jpg$|.*[0-9]+-cart_default.jpg$' -exec cp -f {} images/ \;



Note:
- This script delete $TEMPDIR during the execution
- It also replaces exported files if you execute twice

TODO
- Add export images to the script
