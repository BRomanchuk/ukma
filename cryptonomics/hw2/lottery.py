import smartpy as sp


class Lottery(sp.Contract):
    def __init__(self, _admin):
        self.init(admin=_admin, tickets=sp.map(tkey=sp.TInt, tvalue=sp.TAddress), tickets_bought=0)

    @sp.entry_point
    def buy_tickets(self):
        print(sp.amount)
        num_of_tickets = self.validate_operation(sender=sp.sender, amount=sp.amount)
        self.assign_tickets(num_of_tickets=num_of_tickets, address=sp.sender)
        if self.data.tickets_bought == 5:
            self.choose_winner()

    def validate_operation(self, sender, amount):
        sp.verify(amount >= 0.01)
        num_of_tickets = int(amount / 0.01)
        if num_of_tickets > 5 - self.data.tickets_bought:
            num_of_tickets = 5 - self.data.tickets_bought
        if num_of_tickets * 0.01 < amount:
            self.send(sender, amount - num_of_tickets * 0.01)
        return num_of_tickets

    def assign_tickets(self, num_of_tickets, address):
        for i in sp.range(self.data.tickets_bought + 1, self.data.tickets_bought + num_of_tickets + 1):
            self.data.tickets[i] = address

    def choose_winner(self):
        winner_int = int(sp.now) % 5 + 1
        self.send(receiver=self.data.tickets[winner_int], amount=0.05)

    def send(self, receiver, amount):
        sp.send(destination=receiver, amount=amount)


@sp.add_test(name='lottery_test')
def lottery_test():
    scenario = sp.test_scenario()
    scenario.h1('reg')

    c1 = Lottery(_admin=sp.address('tz1YoAAENFkwtQmyWNcnSDfEbQXU2JpVz9dQ'))

    scenario += c1
    scenario += c1.buy_tickets()
