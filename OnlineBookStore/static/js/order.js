async function load_orders (){
    let response = await fetch('/api/order');
    let orders = await response.json();
    console.log(orders);


    let container = document.getElementById('container');

    if (orders.size == 0) {
        // No orders
        container.innerHTML = `<div class="content-section">
        <h2 class="article-title"><center>You haven't bought anything.</h2>
        </div>`;
    } else {
        container.innerHTML = `<div class="content-section">
        <h2 class="article-title"><center>My Orders</h2>
		</div>`;
        let content = container.appendChild(document.createElement('div'));
        content.className = 'content-section';

        content.innerHTML = `<div class="row d-flex mb-5 contact-info">
                                <div class="col-md-3 d-flex">
                                    <div class="info bg-white p-4">
                                        <h4 class="book-title">UserName</h4>
                                    </div>
                                </div>
                                <div class="col-md-3 d-flex">
                                    <div class="info bg-white p-4">
                                        <h4 class="book-title">Order Date</h4>
                                    </div>
                                </div>
                                <div class="col-md-3 d-flex">
                                    <div class="info bg-white p-4">
                                        <h4 class="book-title">Amount</h4>
                                    </div>
                                </div>
                                <div class="col-md-3 d-flex">
                                    <div class="info bg-white p-4">
                                        <h4 class="book-title">Receipt</h4>
                                    </div>
                                </div>
                            </div>`
        for (let order of orders.orders) {
            let content_section = content.appendChild(document.createElement('div'));
            content_section.classList.add('content-section');

            let row = content_section.appendChild(document.createElement('div'));
            row.className = 'row d-flex mb-5 contact-info';

            let col_1 = row.appendChild(document.createElement('div'));
            col_1.className = 'col-md-3 d-flex';

            let info_1 = col_1.appendChild(document.createElement('div'));
            info_1.className = 'info bg-white p-4';

            let user_name = info_1.appendChild(document.createElement('h4'));
            user_name.innerText = order.username;

            let col_2 = row.appendChild(document.createElement('div'));
            col_2.className = 'col-md-3 d-flex';

            let info_2 = col_2.appendChild(document.createElement('div'));
            info_2.className = 'info bg-white p-4';

            let order_date = info_2.appendChild(document.createElement('h4'));
            // parse order_date to '%Y-%m-%d' pattern
            order_date.innerText = order.order_date.substring(0, 10);

            let col_3 = row.appendChild(document.createElement('div'));
            col_3.className = 'col-md-3 d-flex';

            let info_3 = col_3.appendChild(document.createElement('div'));
            info_3.className = 'info bg-white p-4';

            let amount = info_3.appendChild(document.createElement('h4'));
            amount.innerText = '₱' + order.amount;

            let col_4 = row.appendChild(document.createElement('div'));
            col_4.className = 'col-md-3 d-flex';

            let info_4 = col_4.appendChild(document.createElement('div'));
            info_4.className = 'info bg-white p-4';

            let receipt = info_4.appendChild(document.createElement('a'));
            receipt.className = 'btn btn-info btn-sm mt-1 mb-1';
            receipt.href = '/detail/' + order.id;
            receipt.innerText = 'Receipt';

        }
    }
}

// run load_orders() when the page is loaded
window.onload = load_orders;
