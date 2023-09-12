From https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-20-04#step-4-starting-docker-registry-as-a-service

htpasswd docker container source from https://github.com/xmartlabs/docker-htpasswd/blob/master/Dockerfile

---

# Step 3 — Setting Up Authentication

Nginx allows you to set up HTTP authentication for the sites it manages, which you can use to limit access to your Docker Registry. To achieve this, you’ll create an authentication file with htpasswd and add username and password combinations to it that will be accepted.

You can obtain the htpasswd utility by installing the apache2-utils package. Do so by running:

```
    sudo apt install apache2-utils -y
```

You’ll store the authentication file with credentials under ~/docker-registry/auth. Create it by running:

```
    mkdir ~/docker-registry/auth
```

Navigate to it:

```
    cd ~/docker-registry/auth
```

Create the first user, replacing username with the username you want to use. The -B flag orders the use of the bcrypt algorithm, which Docker requires:

```
    htpasswd -Bc registry.password username
```

Enter the password when prompted, and the combination of credentials will be appended to registry.password.

Note: To add more users, re-run the previous command without -c, which creates a new file:

```
    htpasswd -B registry.password username
```

Now that the list of credentials is made, you’ll edit docker-compose.yml to order Docker to use the file you created to authenticate users. Open it for editing by running:

```
    nano ~/docker-registry/docker-compose.yml
```

Add the highlighted lines: `~/docker-registry/docker-compose.yml`

```
version: '3'

services:
  registry:
    image: registry:2
    ports:
    - "5000:5000"
    environment:
      REGISTRY_AUTH: htpasswd
      REGISTRY_AUTH_HTPASSWD_REALM: Registry
      REGISTRY_AUTH_HTPASSWD_PATH: /auth/registry.password
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
    volumes:
      - ./auth:/auth
      - ./data:/data
```

You’ve added environment variables specifying the use of HTTP authentication and provided the path to the file htpasswd created. For `REGISTRY_AUTH`, you have specified htpasswd as its value, which is the authentication scheme you are using, and set `REGISTRY_AUTH_HTPASSWD_PATH` to the path of the authentication file. `REGISTRY_AUTH_HTPASSWD_REALM` signifies the name of htpasswd realm.

You’ve also mounted the `./auth` directory to make the file available inside the registry container. Save and close the file.

You can now verify that your authentication works correctly. First, navigate to the main directory:

```
    cd ~/docker-registry
```

Then, run the registry by executing:

```
    docker-compose up
```

In your browser, refresh the page of your domain. You’ll be asked for a username and password.

After providing a valid combination of credentials, you’ll see an empty JSON object:

```
{}
```

This means that you’ve successfully authenticated and gained access to the registry. Exit by pressing CTRL+C.

Your registry is now secured and can be accessed only after authentication.
