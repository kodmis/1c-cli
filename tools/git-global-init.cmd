@chcp 65001

@rem for current user

git config --global user.name "Your Name"
git config --global user.email your@email

@rem global

git config --global core.quotePath false

@rem for Windows

git config --global core.autocrlf true
git config --global core.safecrlf false

@rem for Linux and MacOS
@rem git config --global core.autocrlf input
@rem git config --global core.safecrlf true

git config --global http.postBuffer 1048576000
