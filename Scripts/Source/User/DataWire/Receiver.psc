ScriptName DataWire:Receiver extends ObjectReference

import DataWire:Common

CustomEvent OnData

Keyword Property dw_transmitter Auto Const
int Property Value Auto

DataWire:Common:Data[] Values

Event OnInit()
  Values = new DataWire:Common:Data[0]
  RegisterForRemoteEvent(GetWorkshop(), "OnWorkshopMode")
EndEvent

Event OnWorkshopObjectDestroyed(ObjectReference akActionRef)
  Die()
EndEvent

; TODO: This code is dense enough to warrant some comments
Event DataWire:Transmitter.OnDataInternal(DataWire:Transmitter Source, \
    Var[] Args)
  int NewValue = 0

  DataWire:Common:Data Data = Args[0] as DataWire:Common:Data
  If (Values.Length == 0 && Data.Enabled)
    Values.Add(Data)
  ElseIf (Values.Length == 1 && Data.Source == Values[0].Source)
    If (!Data.Enabled)
      Values.Remove(0)
    Else
      Values[0].Value = Data.Value
      Values[0].Time = Data.Time
    EndIf
  Else
    int i = Values.FindStruct("Source", Data.Source)
    If (i > -1)
      Values.Remove(i)
    EndIf
    If (Data.Enabled)
      i = 0
      While (i < Values.Length && Values[i].Time > Data.Time)
        i += 1
      EndWhile
      Values.Insert(Data, i)
    EndIf
  EndIf

  If (Values.Length)
    NewValue = Values[0].Value
  EndIf

  If (Value != NewValue)
    Value = NewValue

    Var[] Args2 = new Var[1]
    Args2[0] = Value
    SendCustomEvent("OnData", Args2)
  EndIf
EndEvent

Event ObjectReference.OnWorkshopMode(ObjectReference akSender, bool aStart)
  If (aStart)
    Return
  EndIf

  UnregisterForAllCustomEvents()
  int i = 0
  DataWire:Transmitter Transmitter
  ObjectReference[] Transmitters = \
    GetWorkshop().GetRefsLinkedToMe(dw_transmitter)

  While (i < Transmitters.Length)
    Transmitter = Transmitters[i] as DataWire:Transmitter
    If (Transmitter.HasSharedPowerGrid(Self))
      RegisterForCustomEvent(Transmitter, "OnDataInternal")
    EndIf
    i += 1
  EndWhile

  ; it is possible that we'll receive data from a transmitter and then the user
  ; removes the wire connecting us to them. That would result in us having a
  ; phantom value in the Values array. The fix? Simple, when leaving workshop
  ; mode verify that any value we're currently holding came from a transmitter
  ; we're still connected to.
  ; TODO: We should probably be issuing an OnData event here. Some refactoring
  ; is needed to do that without needlessly cluttering things up.
  i = Values.Length - 1
  While (i >= 0)
    If (!Values[i].Source.HasSharedPowerGrid(Self))
      Values.Remove(i)
    EndIf
    i -= 1
  EndWhile
EndEvent

Function Die()
  UnregisterForAllCustomEvents()
  UnregisterForAllRemoteEvents()
  Delete()
EndFunction

DataWire:Receiver Function AsReceiver(ObjectReference This) Global
  Return This as DataWire:Receiver
EndFunction

Function Register(ObjectReference This) Global
  This.RegisterForCustomEvent(AsReceiver(This), "OnData")
EndFunction

Function Unregister(ObjectReference This) Global
  This.UnregisterForCustomEvent(AsReceiver(This), "OnData")
EndFunction
