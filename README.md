# kcheques
Create sample cheques with Rails

Blank cheque taken from: [here](http://www.datemplate.com/postpic/2010/07/blank-check-template-pdf_546131.jpg).

To set this app up yourself you will need Rails, ImageMagick and postgresql. 
Clone this repo, run bundle install and everything should be good to go. To set up the database run `rake db:setup` and `rake db:migrate`. 
I'm using puma as a server instead of WEBrick as suggested by Heroku. 

This app was built with Rails, Bootstrap, JQuery and Imagemagick. Gems I added beyond the Heroku default list are at the top of the gemfile and commented.

You can reach this app at [kcheques](https://kcheques.herokuapp.com). I've never made a rails app before so this was a good quick learning experience! There's probably bugs and there are no unit tests either.