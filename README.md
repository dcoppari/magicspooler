# MagicSpooler API

This webservice is intended to be used to convert documents and url to PDF or other formats.

## Installation

You can build the image using docker

```bash
docker build -t magicspooler .
```

## Running the container

```bash
docker run --rm -p "5000:5000" magicspooler
```

Protect the API with Basic Auth

```bash
docker run --rm -p "5000:5000" -e MAGICSPOOLER_USER=hackerman -e MAGICSPOOLER_PASSWORD=h4ckm3 magicspooler
```

## Using the API

Use Chrome to make a PDF

```bash
curl -u 'hackerman:h4ckm3' -X GET 'http://localhost:5000/chrome/pdf' -d 'url=https://www.google.com' --output document.pdf
```

Use Chrome to make a PNG

```bash
curl -u 'hackerman:h4ckm3' -X GET 'http://localhost:5000/chrome/image' -d 'url=https://www.google.com' --output document.png
```

Use LibreOffice to make a PDF

```bash
curl -u 'hackerman:h4ckm3' -X POST 'http://localhost:5000/libreoffice/pdf' -F 'file=@/home/hackerman/document.odt' --output document.pdf
```

## License
[MIT](https://choosealicense.com/licenses/mit/)
