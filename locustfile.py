import base64

from locust import HttpUser, TaskSet, task
from random import randint, choice


class SockShopUser(HttpUser):

    @task
    def load(self):
        base64string = base64.b64encode(b'user:password')
        
        auth_header = "Basic %s" % base64string.decode('utf-8')
        
        self.client.get("/")
        self.client.get("/login", headers={"Authorization": auth_header})
        catalogue = self.client.get("/catalogue").json()
        category_item = choice(catalogue)
        item_id = category_item["id"]

        self.client.get("/category.html")
        self.client.get("/detail.html?id={}".format(item_id))
        self.client.delete("/cart")
        self.client.post("/cart", json={"id": item_id, "quantity": 1})
        self.client.get("/basket.html")
        self.client.get("/orders")

