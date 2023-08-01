## setup instruction
### To start dev env in windows, please follow the below steps on Windows Cmd or Bash CLI

Assuming you already have nodejs installed.
Run the following command one by one.
```
git clone https://github.com/ekalaiv/IPSS-Microservices.git
git checkout fe/dev
```
If you have not created a new branch for yourself the run the below command
```
git checkout -b <your short name>/fe/dev
```
If you already have your local dev branch then
```
git checkout <your short name>/fe/dev
```
Then change directory to 
```
cd fe/mfp-pay-deduction
npm i
npm start
```

Once successfullt started try accessing http://localhost:11211 in Google Chrome.

### To start dev environment in linux, please run,

```
sudo npm start
```

To build for production, please run

```
sudo npm run build
```

To build dev docker imagee please use the following command

```
sudo docker build -f ./Dockerfile.dev -t mfp-pay-deduction-image-dev .
```
To build prod docker imagee please use the following command

```
sudo docker build -f ./Dockerfile.prod -t mfp-pay-deduction-image-prod .
```

To start a development container, please run

```
sudo docker container run -d -p 11211:11211 --name mfp-pay-deduction-dev mfp-pay-deduction-image-dev
```

To start a prod container, please run

```
sudo docker container run -d -p 11211:80 --name mfp-pay-deduction-prod mfp-pay-deduction-image-prod
```

To bash into to the container, please use

```
 sudo docker exec -it mfp-pay-deduction-dev bash
```

To stop the dev container, use,

```
sudo docker container stop mfp-pay-deduction-dev
```

To remove the dev container, use,

```
sudo docker container rm mfp-pay-deduction-dev
```

To remove the dev image, use,

```
sudo docker image rm mfp-pay-deduction-image-dev
```