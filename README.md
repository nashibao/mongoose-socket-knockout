# mongoose-socket

mongoose -> html binding with socket.io and knockout.js

## 1. dependencies

### client side

- knockout.js
- component/component


### server side

- node.js
- express.js
- mongoose(mongodb)

## 2. how to run the test

- 2.1 require mongodb, clone this repo and prepare submodules.
- 2.2 install express and component globally

```bash
cd mongoose-socket
npm install express component -g
```

- 2.3 install npm modules

```bash
npm install
```

- 2.4 prepare components

```bash
cd source/public/component
make
```

- 2.5 compile

```bash
cd mongoose-socket
grunt
```

- (2.6) watch grunt to compile

```bash
grunt watch
```
- 2.7 run

```bash
./app.sh
```

## 3. no api documents!

if you would like to use this module, please view these script files.

### client side

https://github.com/nashibao/mongoose-socket/blob/master/source/public/component/index.coffee


### server side

https://github.com/nashibao/mongoose-socket/blob/master/source/apps/message/index.coffee


## License

The MIT License


