git clone https://github.com/sensiflow/sensi-web-api
git clone https://github.com/sensiflow/sensi-web
git clone https://github.com/sensiflow/image-processor

echo "Building web application distribution files..."

cd sensi-web

npm install
npm run build

Xcopy /E /I dist/* ..\sensi-web-api\src\main\resources\static\
Xcopy /E /I public/* ..\sensi-web-api\src\main\resources\static\

cd ..

echo "Booting web-api jar file"

cd sensi-web-api

./gradlew.bat bootjar

cd ..