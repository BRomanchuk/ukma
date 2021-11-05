import smartpy as sp


class BRToken(sp.Contract):
    def __init__(self, admin):
        self.init(paused=False, balances=sp.big_map(sp.TAdresse, sp.TInt), admin=admin)

    @sp.entry_point
    def transfer(self, params):
        pass

    @sp.entry_point
    def approve(self, params):
        pass

    @sp.entry_point
    def set_pause(self, params):
        pass

    @sp.entry_point
    def set_administrator(self, params):
        pass

    @sp.entry_point
    def mint(self, params):
        pass

    @sp.entry_point
    def burn(self, params):
        pass

    @sp.entry_point
    def get_balance(self, params):
        pass

    @sp.entry_point
    def get_allowance(self, params):
        pass

    @sp.entry_point
    def get_total_supply(self, params):
        pass

    @sp.entry_point
    def get_administrator(self, params):
        pass