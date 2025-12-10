# How to Get the Download URLs

## Method 1: Use this Bookmarklet (Easiest)

1. Go to https://figshare.com/s/9d084ff84f3822d2bf17
2. Wait for all 63 files to load
3. Press **F12** to open Developer Tools
4. Click the **Console** tab
5. Paste this code and press Enter:

```javascript
var urls = []; document.querySelectorAll('button, a').forEach(function(el) { var href = el.getAttribute('href') || el.getAttribute('data-href') || ''; if (href.includes('ndownloader')) urls.push(href.startsWith('http') ? href : 'https://figshare.com' + href); }); if (urls.length === 0) { var text = document.body.innerHTML; var matches = text.match(/ndownloader\/files\/\d+/g); if (matches) urls = [...new Set(matches)].map(m => 'https://figshare.com/' + m); } console.log('Found ' + urls.length + ' URLs:'); console.log(urls.join('\n'));
```

6. Copy all the URLs that appear
7. Paste them into `urls.txt` in this folder

---

## Method 2: Manual Copy (Works Always)

1. Go to https://figshare.com/s/9d084ff84f3822d2bf17
2. For EACH of the 63 files:
   - Right-click the "Download" button
   - Click "Copy link address"
   - Paste into `urls.txt`

---

## Method 3: Check if IDs are Sequential

1. Copy the download link for the **first** file
2. Copy the download link for the **last** file
3. If they look like:
   - First: `https://figshare.com/ndownloader/files/50650001`
   - Last: `https://figshare.com/ndownloader/files/50650063`
4. Then run this in the terminal:

```bash
for i in $(seq 50650001 50650063); do
    echo "https://figshare.com/ndownloader/files/$i"
done > urls.txt
```

---

## After Getting URLs

Run the download script:

```bash
./download_from_urls.sh
```

Files will be saved to `./dataset/`
