Scriptname DataWire:TransmitterExample extends ObjectReference

DataWire:Transmitter Transmitter
int i = 0

Event OnWorkshopObjectPlaced(ObjectReference akReference)
  Transmitter = DataWire:Transmitter.AsTransmitter(Self)
  Transmitter.Enabled = True
EndEvent

Event OnActivate(ObjectReference akActionRef)
  i += 1
  Transmitter.Value = i
EndEvent
