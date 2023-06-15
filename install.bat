git clone https://github.com/sensiflow/sensi-web-api
git clone https://github.com/sensiflow/sensi-web
git clone https://github.com/sensiflow/image-processor

echo "Building web application distribution files..."

cd sensi-web

call npm run build

mkdir ..\sensi-web-api\src\main\resources\static\
Xcopy /E /I /Y dist\* ..\sensi-web-api\src\main\resources\static\
Xcopy /E /I /Y public\* ..\sensi-web-api\src\main\resources\static\

cd ..

echo "Booting web-api jar file"

cd sensi-web-api

./gradlew.bat bootjar

cd ..