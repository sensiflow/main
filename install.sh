git clone https://github.com/sensiflow/sensi-web-api
git clone https://github.com/sensiflow/sensi-web
git clone https://github.com/sensiflow/image-processor

echo "Building webApp distribution"

cd sensi-web

npm run build

mkdir -p ../sensi-web-api/src/main/resources/static/
cp -r dist/* ../sensi-web-api/src/main/resources/static/
cp -r public/* ../sensi-web-api/src/main/resources/static/

echo "Booting web-api jar"

cd ..

cd sensi-web-api

chmod +x ./gradlew

./gradlew bootjar

cd ..