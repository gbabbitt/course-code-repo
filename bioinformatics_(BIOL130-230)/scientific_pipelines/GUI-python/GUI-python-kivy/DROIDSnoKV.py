#!/usr/bin/env python
import os
from kivy.app import App
from kivy.uix.button import Button
from kivy.uix.togglebutton import ToggleButton
from kivy.uix.label import Label
from kivy.uix.gridlayout import GridLayout
from kivy.uix.textinput import TextInput
from kivy.uix.checkbox import CheckBox

class DroidsApp(App):
    def build(self):
        return MyLayout()
    
class MyLayout(GridLayout):
    def __init__(self, **kwargs):
        super(MyLayout, self).__init__(**kwargs)
        self.cols = 1
        self.rows = 10
        # button list
        self.add_widget(Label(text ='system with dual GPU (no SLI)')) 
        self.gpu = CheckBox(active = True) 
        self.add_widget(self.gpu)
        self.btn1 =  Button(text='single protein')
 #                  font_size ="20sp", 
  #                 background_color =(1, 1, 1, 1), 
   #                color =(1, 1, 1, 1),  
    #               size =(32, 10), 
     #              size_hint =(.3, .1), 
      #             pos =(100, 250))
        if self.gpu.active == False:
            self.btn1.bind(on_press = self.callback1)
        if self.gpu.active == True:
            self.btn1.bind(on_press = self.callback2)
        self.add_widget(self.btn1)      
        self.btn2 =  Button(text='protein-DNA')
#                   font_size ="20sp", 
 #                  background_color =(1, 1, 1, 1), 
  #                 color =(1, 1, 1, 1),  
   #                size =(32, 10), 
    #               size_hint =(.3, .1), 
     #              pos =(200, 250))
        if self.gpu.active == False:
            self.btn2.bind(on_press = self.callback3)
        if  self.gpu.active == True:
            self.btn2.bind(on_press = self.callback4)
        self.add_widget(self.btn2)
    
            
    
    # button callback actions
    def callback1(self, event): 
        print("running DROIDS on single GPU - single protein analysis") 
        cmd = 'perl GUI_START_DROIDSss.pl'
        os.system(cmd)
    def callback2(self, event): 
        print("running DROIDS on dual GPU - single protein analysis") 
        cmd = 'perl GUI_START_DROIDSss_dualGPU.pl'
        os.system(cmd)    
    def callback3(self, event): 
        print("running DROIDS on single GPU - protein-DNA analysis") 
        cmd = 'perl GUI_START_DROIDSdp1.pl'
        os.system(cmd)
    def callback4(self, event): 
        print("running DROIDS on dual GPU - protein-DNA analysis") 
        cmd = 'perl GUI_START_DROIDSdp1_dualGPU.pl'
        os.system(cmd)    

if __name__ == '__main__':
    DroidsApp().run()
