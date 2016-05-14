#!/usr/bin/env python2.7
# -*- coding: utf-8 -*-

import curses
from curses import panel

import pokeyworks

class PokeyMenu(object):

    """ Displays curses-based menus based on the passed options """

    def __init__(self,items,stdscreen):
        self.window = stdscreen.subwin(0,0)
        self.window.keypad(1)
        self.panel = panel.new_panel(self.window)
        self.panel.hide()
        panel.update_panels()

        self.position = 0
        self.items = items
        self.items.append(('Quick Exit','exit'))

    def navigate(self,n):
        self.position += n
        if self.position < 0:
            self.position = 0
        elif self.position >= len(self.items):
            self.position = len(self.items)-1

    def display(self):
        self.panel.top()
        self.panel.show()
        self.window.clear()

        while True:
            self.window.refresh()
            curses.doupdate()
            for index, item in enumerate(self.items):
                if index == self.position:
                    mode = curses.A_REVERSE
                else:
                    mode = curses.A_NORMAL

                msg = '{0}. {1}'.format(index,item[0])
                self.window.addstr(1+index,1,msg,mode)

            key = self.window.getch()

            if key in [curses.KEY_ENTER, ord('\n')]:
                if self.position == len(self.items)-1:
                    break # Exit
                else:
                    self.items[self.position][1]()

            elif key == curses.KEY_UP:
                self.navigate(-1)

            elif key == curses.KEY_DOWN:
                self.navigate(1)

        self.window.clear()
        self.panel.hide()
        panel.update_panels()
        curses.doupdate()

class TestApp(object):

    def __init__(self, stdscreen):
        self.screen = stdscreen
        curses.curs_set(0)

        submenu_items = [
            ('beep',curses.beep),
            ('flash',curses.flash)
            ]
        submenu = PokeyMenu(submenu_items, self.screen)

        main_menu_items = [
            ('beep',curses.beep),
            ('flash',curses.flash),
            ('submenu',submenu.display)
            ]

        main_menu = PokeyMenu(main_menu_items, self.screen)
        main_menu.display()

def menu_test():
    curses.wrapper(TestApp)
