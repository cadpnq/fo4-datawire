ScriptName DataWire:ReceiverExample extends ObjectReference

Event OnWorkshopObjectPlaced(ObjectReference akReference)
  DataWire:Receiver.Register(Self)
EndEvent

Event OnWorkshopObjectDestroyed(ObjectReference akActionRef)
  DataWire:Receiver.Unregister(Self)
EndEvent

Event DataWire:Receiver.OnData(DataWire:Receiver akSender, Var[] akArgs)
	Debug.MessageBox(akArgs[0])
EndEvent
