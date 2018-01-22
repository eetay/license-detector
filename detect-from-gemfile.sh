GEM_INFO=$(mktemp /tmp/license-det-yarninfo.XXXXXX)
LIBS=`cat $*  | grep  "(" | sed 's/ //g' | sed 's/(.*$//g' | sort | uniq`
echo "processing `echo $LIBS | wc -w` libs" 1>&2
for i in $LIBS; do
  gem list --details $i | awk '/^'$i'/ { a=a+1 } {if (a==1) { print $0 }}' > $GEM_INFO
  WEBPAGE=`cat $GEM_INFO | grep -i "homepage:" | sed 's/^.*page://g'| sed 's/^ *//g' | sed 's/ +$//g' | sed ':a;N;$!ba;s/\n/ /g'`
  LICENSE=`cat $GEM_INFO | grep -i "license:" | sed 's/^.*cense://g'| sed 's/^ *//g' | sed 's/ +$//g' | sed ':a;N;$!ba;s/\n/ /g'`
  AUTHOR=`cat $GEM_INFO | grep -i "author:" | sed 's/^.*thor://g'| sed 's/^ *//g' | sed 's/ +$//g' | sed ':a;N;$!ba;s/\n/ /g'`
  echo "$i,$WEBPAGE,$GIT,$LICENSE,$AUTHOR,$VFC"
done
rm -rf $YARN_INFO
