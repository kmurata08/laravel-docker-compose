# laravel-docker-compose

Build develop environment of laravel application.

## Usage

### Create New Application

```bash
$ git clone git@github.com:naoyaUda/laravel-docker-compose.git
$ cd laravel-docker-compose
$ make
$ cp -r $your_install_version_dir /path/to/your/app/name
```
- option
  - You can choose version of intallation laravel flamework. e.g.

```
$ make        // Install laravel latest
$ make v=7    // Install laravel 7.0.0
$ make v=6.12 // Install laravel 6.12
```

### Installation

```bash
$ cd your-app-name
$ vi .env.example

>>>
- PROJECT=project-name
+ PROJECT=YOUR_APP_NAME
- DB_HOST=127.0.0.1
+ DB_HOST=mysql
- DB_PASSWORD=
+ DB_PASSWORD=PASSWORD
- REDIS_HOST=127.0.0.1
+ REDIS_HOST=redis
<<<

$ make install
```

### Using XDebug

- Simply copy .vscode directory to your app. You can use XDebug on vs code.

```bash
$ cp .vscode /pass/to/your/app
$ echo .vscode/ >> .gitignore
```

### E2E test with laravel Dusk

- First, Install laravel dusk.

```bash
$ make app
$ composer require --dev laravel/dusk
$ php artisan dusk:install
```

- Second, Change DuskTestCase below.

```
   protected function baseUrl()
    {
        return config('dusk.host');
    }
    
    /**
     * Prepare for Dusk test execution.
     *
     * @beforeClass
     * @return void
     */
    public static function prepare()
    {
        // disable compatible chrome Driver.
        // static::startChromeDriver();
    }
    
    /**
     * Create the RemoteWebDriver instance.
     *
     * @return \Facebook\WebDriver\Remote\RemoteWebDriver
     */
    protected function driver()
    {
        $options = (new ChromeOptions)->addArguments([
            '--disable-gpu',
            '--headless',
            '--no-sandbox',
            '--window-size=1920,1080',
        ]);

        return RemoteWebDriver::create(
            config('dusk.chrome_driver_host'),
            DesiredCapabilities::chrome()->setCapability(
                ChromeOptions::CAPABILITY,
                $options
            )
        );
    }
```

### CI on Github Actions

- rename sample workflow.

```
$ cd .github/workflows
$ mv sample-workflow.yml.sample build-and-test.yml
```

- you should change some settings in `build-and-test.yml`

```
>>>
- name: YOUR_ACTION_NAME
~~~
container:
  image: 708u/laravel-alpine:7.4.3-node-browser
  env:
    APP_ENV: testing
    APP_URL: http://localhost
    DB_CONNECTION: mysql
    DB_HOST: mysql
-   DB_DATABASE: YOUR_TESTING_DATABASE
~~~
services:
  mysql:
    image: mysql:5.7
    env:
-     MYSQL_DATABASE: YOUR_DATABASE_NAME
<<<

```
