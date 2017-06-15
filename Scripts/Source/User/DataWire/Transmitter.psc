Scriptname DataWire:Transmitter extends ObjectReference

import DataWire:Common

CustomEvent OnDataInternal

Keyword Property dw_transmitter Auto Const

int _Value
int Property Value
  int Function Get()
    Return _Value
  EndFunction
  Function Set(int Val)
    _Value = Val
    SendEvent()
  EndFunction
EndProperty

bool _Enabled
bool Property Enabled
  bool Function Get()
    Return _Enabled
  EndFunction
  Function Set(bool Val)
    _Enabled = Val
    SendEvent()
  EndFunction
EndProperty

Event Oninit()
  SetLinkedRef(GetWorkshop(), dw_transmitter)
EndEvent

Function SendEvent()
  Var[] Args = new Var[1]
  DataWire:Common:Data Data = New DataWire:Common:Data
  Data.Value = _Value
  Data.Time = Utility.GetCurrentGameTime()
  Data.Source = Self
  Data.Enabled = _Enabled

  Args[0] = Data
  SendCustomEvent("OnDataInternal", Args)
EndFunction

DataWire:Transmitter Function AsTransmitter(ObjectReference This) Global
  Return This as DataWire:Transmitter
EndFunction
