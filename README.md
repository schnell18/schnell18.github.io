# Introduction

Personal website based on [Hugo Academic CV Theme](https://github.com/HugoBlox/theme-academic-cv).

## Simple Hugo Website Todo List
### Setup

- Install Hugo
- Create new site: hugo new site mywebsite
- Choose and install a theme
- Configure hugo.toml (site title, baseURL, theme)

### Content

- Write Home page
- Create first blog post
- Add profile photo
- Test locally: hugo server -D

### Publish

- Register a domain (namecheap, godaddy)
- Build site: hugo
- Upload to hosting (GitHub Pages, Netlify, or web host)
- Set up custom domain
- Enable HTTPS

### Finish

- Test live site
- Share with others
- Plan regular content updates

## Misc
### Additional tools for this repository

- imagemagick
- gitleaks
- uv
- pre-commit
- hugo
- hugo blox
- golang
- neovim (optional)
- tmux (optional)

### Make transparent picture

    magick featured.jpeg -fuzz 45% -transparent white featured.png

Adjust `-fuzz` to get best result.
