# GetSh 💨

simple REST API tester based on `curl`  
lightweight alternative to PostMan for simple projects

## Dependencies
- `curl`
- `jq` - formatting and coloring of json

## How to use

- `getsh <url>`: defaults to **GET** request, returns data and some info about request
- `getsh <url> POST`: specify method (GET, POST, DELETE, PUT, PATCH). If POST, PUT or PATCH open `$EDITOR` and specify json string for the request
- `getsh -d`: output data from last operation - useful for piping

## Examples

### GET

`getsh jsonplaceholder.typicode.com/posts/1`  

returns:
```
GET on jsonplaceholder.typicode.com/posts/1

{
  "userId": 1,
  "id": 1,
  "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
}


Server Response Code:   200
Content Type:           application/json; charset=utf-8
Remote Ip:              172.67.150.206:80
Scheme:                 HTTP
Total Time:             0.146920s
```

### POST

`getsh jsonplaceholder.typicode.com/posts POST`

then specify json string in your editor:

```
{
	"title": "lorem",
	"body": "lorem ipsum",
	"userId": 9
}
```

returns:
```
POST on jsonplaceholder.typicode.com/posts

{
  "title": "lorem",
  "body": "lorem ipsum",
  "userId": 9,
  "id": 101
}


Server Response Code:   201
Content Type:           application/json; charset=utf-8
Remote Ip:              104.28.10.184:80
Scheme:                 HTTP
Total Time:             2.348348s
```
