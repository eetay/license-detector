INFO=$(mktemp /tmp/npmjs-info.XXXXXX)
JS_FILES=`find . -name *.js`
LIBS=`grep -w "//= require" $JS_FILES | sed 's/^.*require//g' | grep -v i18n | grep -v jquery.ui | sed 's/^[. /]*//g' | sed 's/[.]js$//g' | sed 's/\/.*$//g' | sort | uniq`
echo "processing `echo $LIBS | wc -w` libs" 1>&2
for i in $LIBS; do
  VENDOR=`find vendor -name "$i*" | sed ':a;N;$!ba;s/\n/,/g'`
  if [ -n "$VENDOR" ]; then
    WEBPAGE=https://www.npmjs.com/package/$i
    curl "$WEBPAGE" 2> /dev/null > $INFO
    AUTHOR=`cat $INFO | egrep "(Official website|documentation|information).*href" |  sed 's/^.*href=.//g' | sed 's/".*$//g' | sed ':a;N;$!ba;s/\n/,/g'`
    GIT=`cat $INFO | grep "Download.*href" |  sed 's/^.*href=.//g' | sed 's/".*$//g' | sed ':a;N;$!ba;s/\n/,/g'`
    LICENSE=`cat $INFO | grep "Licens.*href" |  sed 's/^.*href=.//g' | sed 's/".*$//g' | sed ':a;N;$!ba;s/\n/,/g'`
    LICENSE2=`cat $INFO | egrep "http://spdx.org/licenses" | sed 's/^[^>]*>//g' | sed 's/<.*$//g' | sed ':a;N;$!ba;s/\n/,/g'`
    if [ -n "$LICENSE" ]; then
      LICENSE="$LICENSE "
    fi
    echo "$i,$WEBPAGE,$GIT,$LICENSE$LICENSE2,$AUTHOR,$VENDOR"
  fi
done
rm -f $INFO
