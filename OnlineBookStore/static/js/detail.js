async function load_detail () {
    // get the order id from the url
    let order_id = window.location.href.split('/')[4];

    let respone = await fetch('/api/order/' + order_id);
    let data = await respone.json();

    let username = document.getElementById('username');
    username.innerText = data.user.username

    let email = document.getElementById('email');
    email.innerText = data.user.email

    let address = document.getElementById('address');
    address.innerText = data.user.address

    let state = document.getElementById('state');
    state.innerText = data.user.state

    let pincode = document.getElementById('pincode');
    pincode.innerText = data.user.pincode

    let id = document.getElementById('id');
    id.innerText = data.order.id

    let order_date = document.getElementById('date');
    order_date.innerText = data.order.order_date.substring(0, 10)
    
    // insert the order details into the table under the book-heading
    for (let book of data.orders) {
        let heading  = document.getElementById('book-heading');
        // create a new row below the heading
        let row = document.createElement('tr');
        // create a new column for the book name
        let book_name = document.createElement('td');
        book_name.innerText = book.title;

        // create a new column for the book price
        let book_price = document.createElement('td');
        book_price.innerText = book.price;

        // place row below the heading
        heading.after(row);
        // place the book name and price in the row
        row.append(book_name);
        row.append(book_price);
    };

    // insert the order total into the table
    let total_1 = document.getElementsByClassName('total-amount')[0];
    total_1.innerText = data.order.amount;

    let total_2 = document.getElementsByClassName('total-amount')[1];
    total_2.innerText = data.order.amount;




}

// load_detail() to window
window.onload = load_detail;
