echo Creating Ubuntu icon...

SPSS_EXISTS=($(find /opt/IBM -name "stats"))
SPSS_TOTAL=${#SPSS_EXISTS[@]}

if [ $SPSS_TOTAL -eq 0 ]; then
    echo "* ERROR: SPSS not found. Install it first."
    exit
elif [ $SPSS_TOTAL -gt 1 ]; then
    echo "* ERROR: More than one SPSS version found."
    exit
fi

CURL_EXISTS=$(which curl)

if [ -z "$CURL_EXISTS" ]; then
    echo "* ERROR: curl not found."
    echo "Run \"sudo apt install curl\""
    exit
fi

DESKTOP_FILE=https://raw.githubusercontent.com/JAlbertoGonzalez/spss-linux-launcher/main/spss.desktop
ICON_FILE=https://raw.githubusercontent.com/JAlbertoGonzalez/spss-linux-launcher/main/spss.png
SAV_FILE=https://raw.githubusercontent.com/JAlbertoGonzalez/spss-linux-launcher/main/application-x-spss-sav.png
MIME_FILE=https://raw.githubusercontent.com/JAlbertoGonzalez/spss-linux-launcher/main/spss-mime.xml

curl $DESKTOP_FILE -o spss.desktop
curl $ICON_FILE -o spss.png
curl $SAV_FILE -o application-x-spss-sav.png
curl $MIME_FILE -o spss-mime.xml

SPSS_EXISTS=${SPSS_EXISTS[0]}
sed -i "s|Exec=.*|Exec=$SPSS_EXISTS %u|" spss.desktop

cat spss.desktop

sudo mv ./spss.png /usr/share/pixmaps/
sudo mv ./spss.desktop /usr/share/application
sudo mv ./application-x-spss-sav.png /usr/share/icons/hicolor/scalable/mimetypes

xdg-mime install spss-mime.xml
sudo update-mime-database /usr/share/mime
sudo update-icon-caches /usr/share/icons/*
