// update user details
async function updateUserDetails() {
    
    // get user details from the form
    const userDetails = {
        username: $('#username').val(),
        email: $('#email').val(),
        image_file: $('#image_file').val(),
        address: $('#address').val(),
        state: $('#state').val(),
        pincode: $('#pincode').val()};

    // update user details using api 
    let response = await fetch('/api/account', {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(userDetails)
    });

    // get response in json format
    let responseData = await response.json();

    // if user details are updated successfully
    if (responseData.status == 'success') {
        // show success message
        window.alert('User details updated successfully');
    }
    // if user details are not updated successfully
    else {
        // show error message
        window.alert('User details not updated');
    }
}


// load user details from api/account

async function loadUserDetails() {
    let response = await fetch('/api/account');
    let data = await response.json();

    console.log(data);

    let media_div = document.getElementById('media_div');
    media_div.classList.add('media');

    //add image
    let image = media_div.appendChild(document.createElement('img'));
    image.classList.add('rounded-circle');
    image.classList.add('account-img');
    image.src = '/static/Profile_Image/' + data.user.image_file;

    //add body
    let body = media_div.appendChild(document.createElement('div'));
    body.classList.add('media-body');

    // add name
    let name = body.appendChild(document.createElement('h2'));
    name.classList.add('account-heading');
    name.innerText = data.user.username;

    // add email
    let email = body.appendChild(document.createElement('p'));
    email.classList.add('text-secondary');
    email.innerText = data.user.email;

    let fieldset = document.getElementById('fset');

    // add username 
    let username = fieldset.appendChild(document.createElement('div'));
    username.classList.add('form-group');

    let username_label = username.appendChild(document.createElement('label'));
    username_label.classList.add('form-control-label');
    username_label.innerText = 'Username';

    let username_input = username.appendChild(document.createElement('input'));
    username_input.classList.add('form-control');
    username_input.classList.add('form-control-lg');
    username_input.id = 'username';

    username_input.value = data.user.username;

    // add email
    let email_div = fieldset.appendChild(document.createElement('div'));
    email_div.classList.add('form-group');

    let email_label = email_div.appendChild(document.createElement('label'));
    email_label.classList.add('form-control-label');
    email_label.innerText = 'Email';

    let email_input = email_div.appendChild(document.createElement('input'));
    email_input.classList.add('form-control');
    email_input.classList.add('form-control-lg');
    email_input.id = 'email';

    email_input.value = data.user.email;

    // add image
    let image_div = fieldset.appendChild(document.createElement('div'));
    image_div.classList.add('form-group');

    let image_label = image_div.appendChild(document.createElement('label'));
    image_label.classList.add('form-control-label');
    image_label.innerText = 'Update Profile Picture';

    let image_input = image_div.appendChild(document.createElement('input'));
    image_input.type = 'file';
    image_input.classList.add('form-control-file');
    image_input.id = 'image_file';

    // add address
    let address_div = fieldset.appendChild(document.createElement('div'));
    address_div.classList.add('form-group');

    let address_label = address_div.appendChild(document.createElement('label'));
    address_label.classList.add('form-control-label');
    address_label.innerText = 'Address';

    let address_input = address_div.appendChild(document.createElement('textarea'));
    address_input.classList.add('form-control');
    address_input.classList.add('form-control-lg');
    address_input.id = 'address';

    address_input.value = data.user.address;

    // add state
    let state_div = fieldset.appendChild(document.createElement('div'));
    state_div.classList.add('form-group');

    let state_label = state_div.appendChild(document.createElement('label'));
    state_label.classList.add('form-control-label');
    state_label.innerText = 'State';

    let state_input = state_div.appendChild(document.createElement('input'));
    state_input.classList.add('form-control');
    state_input.classList.add('form-control-lg');
    state_input.id = 'state';

    state_input.value = data.user.state;

    // add pincode
    let pincode_div = fieldset.appendChild(document.createElement('div'));
    pincode_div.classList.add('form-group');

    let pincode_label = pincode_div.appendChild(document.createElement('label'));
    pincode_label.classList.add('form-control-label');
    pincode_label.innerText = 'Pincode';

    let pincode_input = pincode_div.appendChild(document.createElement('input'));
    pincode_input.classList.add('form-control');
    pincode_input.classList.add('form-control-lg');
    pincode_input.id = 'pincode';
    
    pincode_input.value = data.user.pincode;

    // add update button
    let form = document.getElementById('acctfrm');

    let update_btn = form.appendChild(document.createElement('button'));
    update_btn.classList.add('btn');
    update_btn.classList.add('btn-outline-info');

    update_btn.innerText = 'Update';
    update_btn.type = 'submit';
    update_btn.name = 'update';
    update_btn.id = 'update';
    update_btn.value = 'update';

    update_btn.addEventListener('click', updateUserDetails);
}

window.addEventListener('load', loadUserDetails);
