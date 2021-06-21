import base64

from locust import HttpUser, task


class SockShopUser(HttpUser):

    @task
    def load(self):

        self.client.get("/")
