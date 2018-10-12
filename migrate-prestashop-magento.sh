#!/bin/bash


source config/settings.sh

rm -Rf $OUTDIR
mkdir $OUTDIR
rm -Rf $TEMPDIR
mkdir $TEMPDIR
mkdir $EXPORTDIR


source inc/initial_commands.sh
#FNAME+=/$(date +%Y.%m.%d)-$TABLE



#  printf '%s\n' "$p"

	TABLE=$p
	TABLEID=$(echo $p |  sed 's/ps_//g')
	TABLE_LANG=$TABLE
	TABLE_LANG+='_lang'
	FNAME=$OUTDIR
	FNAME+=/$TABLE
	FNAME+=.csv
	#(1)creates empty file and sets up column names using the information_schema
	# Heron query to dump e nao para CSV
	#"SELECT COLUMN_NAME FROM information_schema.COLUMNS C WHERE ( table_name = '$TABLE' OR table_name = '$TABLE_LANG') AND TABLE_SCHEMA = '$DBNAME' ;" \
	#mysql -u root -panimalize09  $DBNAME -B -e \
	#"SELECT COLUMN_NAME FROM information_schema.COLUMNS C WHERE  table_name = '$TABLE'  AND TABLE_SCHEMA = '$DBNAME' ;" \
	#| awk '{print $1}' \
	#| grep -iv ^COLUMN_NAME$ | sed 's/^/"/g;s/$/"/g' | tr '\n' ';' > $FNAME

	#(2)appends newline to mark beginning of data vs. column titles
	#echo "" >> $FNAME



	# Heron query only to dump e nao para CSV

      	#mysqldump -h localhost -uroot -panimalize09 $DBNAME --fields-enclosed-by=\" --fields-terminated-by=\; $TABLE -T$OUTDIR             
      	#mysqldump -h localhost -uroot -panimalize09 $DBNAME --fields-enclosed-by=\" --fields-terminated-by=\; $TABLE -T$OUTDIR -e "


	rm -f $DBPATH/pscloneoriginal02/produtos.csv	
	rm -f $DBPATH/pscloneoriginal02/product_image.csv
	rm -f $DBPATH/pscloneoriginal02/customer_composite.csv

#,pl.meta_description
#,'<p>fake description'
#, pl.description
		#,'<p>fake description'
		#,'<p>fake description'
#,pl.meta_description
#,(SELECT GROUP_CONCAT(cl.name SEPARATOR '/') FROM ps_category_product cp LEFT JOIN ps_category_lang cl ON cl.id_category=cp.id_category 
#WHERE cp.id_product=p.id_product AND cl.id_lang='5' GROUP BY cp.id_product) as categories
	#SET SESSION sql_mode='NO_BACKSLASH_ESCAPES' ;
		#, REPLACE( REPLACE(pl.description,'\r','')  ,'\n','')
		#, CONCAT('',pl.description)
		#,'Default Category/Cloro'
		#,CONCAT('Default Category/',xpto)
		#, 'Catalog, Search'
      	mysql -h localhost -uroot -panimalize09 $DBNAME -B -e "
	SELECT 
		IF(reference like '' ,CONCAT('POOL.000',p.id_product), reference) as sku 
		,''
		,'Default'
		,'simple' 
		, CONCAT('Default Category/'
		    ,(SELECT GROUP_CONCAT(cl.name ORDER BY cp.id_category ASC SEPARATOR '/') FROM ps_category_product cp LEFT JOIN ps_category_lang cl ON cl.id_category=cp.id_category 
			WHERE cp.id_product=p.id_product AND cl.id_lang='5' GROUP BY cp.id_product) 
		)
		, 'base'
		, pl.name 
		, HTML_UnEncodeHMB(pl.description)
		, HTML_UnEncodeHMB(pl.description_short)
		, weight
		, '1' 
		, 'Taxable Goods'
		, 'Catálogo, Pesquisa'
		, p.price
		, ''
		, ''
		, ''
		, pl.link_rewrite
		, pl.meta_title
		, pl.meta_keywords 
		, HTML_UnEncodeHMB(pl.meta_description)
		, p.date_add
		, p.date_upd
		,'has_options=1,quantity_and_stock_status=In Stock,required_options=0'
		,IF(active = '0' , '0' , quantity)
		,'1'
		,'2'
		,'0'
		,'2'
		,'0'
		,'1'

FROM ps_product p 
LEFT JOIN ps_product_lang pl ON pl.id_product=p.id_product
WHERE pl.id_lang='5'  
AND p.reference!='18567' 
AND p.reference!='99.206F' 
AND p.reference!='7890037004767' 
AND p.reference!='00061' 
AND p.reference!='Linha Mestra Slim' 
INTO OUTFILE 'produtos.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n' 
	"  
#INTO OUTFILE 'produtos.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' 
	FRESULT=$OUTDIR
	FRESULT+=/$TABLE
	FRESULT+='.txt'



# IMAGES
# trabalhar nisso
#  	find . -regextype posix-awk -iregex '.*[0-9]+.jpg$|.*[0-9]+-small_default.jpg$' -exec cp -f {} images/ \;
#find . -regextype posix-awk -iregex '.*[0-9]+.jpg$|.*[0-9]+-small_default.jpg$|.*[0-9]+-cart_default.jpg$' -exec cp -f {} images/ \;


	#cat $DBPATH/pscloneoriginal02/produtos.csv   |  sed  -e 's/\\\n//g p' > $DBPATH/pscloneoriginal02/produtos2.csv
	cat $DBPATH/pscloneoriginal02/produtos.csv   |  sed  -e ':a;N;$!ba;s/\\\n//g p;s/> \\//g p' > $DBPATH/pscloneoriginal02/produtos2.csv
	cat $DBPATH/pscloneoriginal02/produtos2.csv   |  sed  -e 's/\\\"//g p' > $DBPATH/pscloneoriginal02/produtos3.csv
	cat $DBPATH/pscloneoriginal02/produtos3.csv   |  sed  -e 's/ZZZZ\\//g p' > $DBPATH/pscloneoriginal02/produtos4.csv
	cat $DBPATH/pscloneoriginal02/produtos4.csv   |  sed  -e 's/\r//g p' > $DBPATH/pscloneoriginal02/produtos5.csv
	cat headers/catalog_product.hdr $DBPATH/pscloneoriginal02/produtos5.csv > $EXPORTZIPDIR/produtos20.csv
	zip $EXPORTZIPDIR/produtos.zip $EXPORTZIPDIR/produtos20.csv
	#cat headers/catalog_product.hdr $DBPATH/pscloneoriginal02/produtos.csv > $EXPORTZIPDIR/produtos20.csv


	    #, CONCAT(CONCAT('images/',i.id_image),'-small_default.jpg')
	    #, il.legend
	    #, CONCAT(CONCAT('images/',i.id_image),'-cart_default.jpg')
	    #, il.legend

      	mysql -h localhost -uroot -panimalize09 $DBNAME -B -e "
	SELECT
	    IF(reference like '' ,CONCAT('POOL.000',p.id_product), reference) as sku
	    , CONCAT(CONCAT('images/',i.id_image),'.jpg')
	FROM ps_image i 
	LEFT JOIN ps_image_lang il ON i.id_image=il.id_image 
	LEFT JOIN ps_product p ON i.id_product=p.id_product 
	WHERE il.id_lang='5' 
AND p.reference!='18567' 
AND p.reference!='99.206F' 
AND p.reference!='7890037004767' 
AND p.reference!='00061' 
AND p.reference!='Linha Mestra Slim' 
	INTO OUTFILE 'product_image.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' 
"

	cat $DBPATH/pscloneoriginal02/product_image.csv |sed  -e ':a;N;$!ba;s/\\\n//g p;s/> \\//g p' > $DBPATH/pscloneoriginal02/product_image2.csv
	cat $DBPATH/pscloneoriginal02/product_image2.csv|sed  -e 's/\\\"//g p' >   $DBPATH/pscloneoriginal02/product_image3.csv
	cat $DBPATH/pscloneoriginal02/product_image3.csv|sed  -e 's/ZZZZ\\//g p' > $DBPATH/pscloneoriginal02/product_image4.csv
	cat $DBPATH/pscloneoriginal02/product_image4.csv|sed  -e 's/\r//g p' >     $DBPATH/pscloneoriginal02/product_image5.csv
	cat $DBPATH/pscloneoriginal02/product_image5.csv|sed  -e 's/”//g p' >     $DBPATH/pscloneoriginal02/product_image6.csv
	cat $DBPATH/pscloneoriginal02/product_image6.csv|sed  -e 's/ZZZZZ\//-/g p' >     $DBPATH/pscloneoriginal02/product_image7.csv
	cat headers/product_image.hdr $DBPATH/pscloneoriginal02/product_image7.csv > $EXPORTZIPDIR/produtos20_images.csv
	zip $EXPORTZIPDIR/produtos_images.zip  $EXPORTZIPDIR/produtos20_images.csv

#	cat $FRESULT >> $FNAME
	#cat $DBPATH/pscloneoriginal02/produtos.csv   |  sed  -e ':a;N;$!ba;s/>\\\n|> \\\n/>/g p' > $DBPATH/pscloneoriginal02/produtos2.csv
	#cat magento_csv/catalog_product_temp2.hdr $DBPATH/pscloneoriginal02/produtos2.csv > $EXPORTZIPDIR/produtos20.csv


# Testado

       mysql -h localhost -uroot -panimalize09 $DBNAME -B -e "
	SELECT DISTINCT email,'base','admin','',c.date_add,'Admin',''
        ,IF(c.birthday IS NULL,'', c.birthday )
	,c.firstname
	,
	CASE 
	    WHEN id_gender = '1' then 'Male'
	    WHEN id_gender = '2' then 'Female'
	    WHEN id_gender = '3' then 'Female'
	    WHEN id_gender = '4' then ''
	    WHEN id_gender = '9' then ''
	    WHEN id_gender = '0' then ''
	    WHEN id_gender = '\N' then ''
	    WHEN id_gender IS NULL then ''
	END
	,'1',c.lastname,'',passwd,'','','','0','','','1','' 
	,IF(a.city IS NULL,'endereceo nao especificado', a.city )
	,IF(a.company IS NULL,'empresa nao especificada', a.company )
	, 'BR' ,''
	,IF(a.firstname IS NULL,c.firstname, a.firstname )
	,IF(a.lastname IS NULL,c.lastname, a.lastname )
	, ''
	,IF(a.postcode IS NULL,'99999-999', a.postcode )
	, ''
	, ''
	,IF(a.address1 IS NULL,'endereceo nao especificado', CONCAT(a.address1,' , ',a.address2)),''
	,IF(a.phone IS NULL OR a.phone ='' ,'999999999', a.phone)
	,'','1','1'
	FROM ps_customer c LEFT JOIN  ps_address a ON c.id_customer=a.id_customer 
	GROUP BY email 
	ORDER BY email ASC 
	INTO OUTFILE 'customer_composite.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n' 
"
	cat $DBPATH/pscloneoriginal02/customer_composite.csv |sed  -e ':a;N;$!ba;s/\\\n//g p;s/> \\//g p' > $DBPATH/pscloneoriginal02/customer_composite2.csv
	cat $DBPATH/pscloneoriginal02/customer_composite2.csv|sed  -e 's/\\\"//g p' >   $DBPATH/pscloneoriginal02/customer_composite3.csv
	cat $DBPATH/pscloneoriginal02/customer_composite3.csv|sed  -e 's/ZZZZ\\//g p' > $DBPATH/pscloneoriginal02/customer_composite4.csv
	cat $DBPATH/pscloneoriginal02/customer_composite4.csv|sed  -e 's/\r//g p' >     $DBPATH/pscloneoriginal02/customer_composite5.csv
	cat $DBPATH/pscloneoriginal02/customer_composite5.csv|sed  -e 's/”//g p' >     $DBPATH/pscloneoriginal02/customer_composite6.csv
	cat $DBPATH/pscloneoriginal02/customer_composite6.csv|sed  -e 's/ZZZZZ\//-/g p' >     $DBPATH/pscloneoriginal02/customer_composite7.csv
	cat headers/customer_composite.hdr $DBPATH/pscloneoriginal02/customer_composite7.csv > $EXPORTDIR/customer_composite.csv 
	zip $EXPORTZIPDIR/customer_composit.zip  $EXPORTDIR/customer_composite.csv




	echo "created $DBPATH/pscloneoriginal02/produtos.csv"
	echo "created $DBPATH/pscloneoriginal02/product_image.csv"
	echo "created $DBPATH/pscloneoriginal02/customer_composite.csv"
	echo "created $EXPORTZIPDIR/produtos.zip"
	echo "created $EXPORTZIPDIR/produtos_images.zip"
	echo "created $EXPORTZIPDIR/customer_composite.zip "                 
	echo "done..."


