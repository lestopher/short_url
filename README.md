Generic URL Shortener Using MongoDB
===================================
You're free to fork the project. Find it in action at [evi.io](http://evi.io)

## To clone

```bash
git clone https://github.com/lestopher/short_url.git
```

## To use

```bash
bundle update
rails s
```

## Caveat

You'll notice that there are some gems in the Gemfile that pertain to Heroku use. Comment them out if it pleases you.  

You'll notice that one of the gems required is therubyracer, which uses Google's V8 javascript engine. There's currently no Windows version, so unless you do some tweaking, this won't run on Windows.


## To do

- Add admin page
- Add tracking to click of links
- Style this bad boy up
- Set 301 redirect upon redirection
- Add anonymous url based administration of url (ie you have an admin url known only to you)

