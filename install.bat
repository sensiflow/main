git clone https://github.com/sensiflow/sensi-web-api
git clone https://github.com/sensiflow/sensi-web
git clone https://github.com/sensiflow/image-processor

echo "Building web application distribution files..."

cd sensi-web

call npm run build

mkdir ..\nginx\static\
Xcopy /E /I /Y dist\* ..\nginx\static\
Xcopy /E /I /Y public\* ..\nginx\static\

cd ..

echo "Booting web-api jar file"

cd sensi-web-api

./gradlew.bat bootjar

cd ..