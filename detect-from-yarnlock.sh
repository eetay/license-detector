YARN_INFO=$(mktemp /tmp/license-det-yarninfo.XXXXXX)
LIBS=`cat $*  | grep "^[a-z]" | sed 's/@.*$//' | sort | uniq`
echo "processing `echo $LIBS | wc -w` libs" 1>&2
for i in $LIBS; do
  VFC=`cd ~/dev; grep -l "^$i@" VisualforceCore/yarn.lock`
  yarn info $i > $YARN_INFO
  LICENSE=`cat $YARN_INFO | awk '/license:/ { if (match($0,/'"'"'/)) {print $0;} else {a=1;} } /type:/ {if (a==1) {print $0; a=2}}' | sed -e "s/^[^']*'//g" -e "s/'.*$//g"`
  GIT=`cat $YARN_INFO | grep "url:.*[.]git'" | sed -e "s/^[^']*'//g" -e "s/'.*$//g" | sed ':a;N;$!ba;s/\n/ /g'`
  WEBPAGE=`cat $YARN_INFO | grep "homepage:" | sed -e "s/^[^']*'//g" -e "s/'.*$//g"`
  AUTHOR=`cat $YARN_INFO | awk '/author:/,/}/ {print $0}' | grep "url:" | sed -e "s/^[^']*'//g" -e "s/'.*$//g"`
  echo "$i,$WEBPAGE,$GIT,$LICENSE,$AUTHOR,$VFC"
done
rm -rf $YARN_INFO
