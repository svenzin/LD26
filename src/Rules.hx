package ;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.ObjectHash;

/**
 * ...
 * @author scorder
 */
interface Phase
{
	function Go(player : Player) : Void;
	function IsValidFor(player : Player, cell : Cell) : Bool;
	function ActionFor(player : Player, cell : Cell) : Void;
	function SuperactionFor(player : Player, cell : Cell) : Void;
}

class PhaseNone implements Phase
{
	public function new() {}
	public function Go(player : Player) { Main.MainConsole.Log("GoNone"); }
	public function IsValidFor(player : Player, cell : Cell) : Bool { return true; }
	public function ActionFor(player : Player, cell : Cell) { Main.MainConsole.Log("ActionForNone"); }
	public function SuperactionFor(player : Player, cell : Cell) { Main.MainConsole.Log("SuperactionForNone"); }
}

class PhaseExplore implements Phase
{
	public function new() {}

	public function Go(player : Player)
	{
		Main.MainConsole.Log("GoExplore");
	}
	
	public function IsValidFor(player : Player, cell : Cell) : Bool
	{
		if (cell.Player == player) return false;
		
		for (other in Main.MainBoard.neighbours(cell))
		{
			if (other.Player == player) return true;
		}
		
		return false;
	}
	
	public function ActionFor(player : Player, cell : Cell)
	{
		Main.MainConsole.Log("ActionForExplore");
		cell.Visible = true;
		cell.Update();
	}

	public function SuperactionFor(player : Player, cell : Cell)
	{
		Main.MainConsole.Log("SuperactionForExplore");
		
		player.Energy -= 1;
		
		cell.Visible = true;
		cell.Update();
		
		for (other in Main.MainBoard.neighbours(cell))
		{
			other.Visible = true;
			other.Update();
		}
	}
}

class PhaseSettle implements Phase
{
	public function new() {}

	public function Go(player : Player) { Main.MainConsole.Log("GoSettle"); }
	
	public function IsValidFor(player : Player, cell : Cell) : Bool
	{
		if (cell.Player == player) return false;
		
		if ((cell.Energy > player.Energy) ||
		    (cell.Military > player.Military))
		{
			return false;
		}
		
		return cell.Visible;
	}
	
	public function ActionFor(player : Player, cell : Cell)
	{
		Main.MainConsole.Log("ActionForSettle");
		player.Energy -= cell.Energy;
		cell.Player = player;
		cell.Update();
	}

		public function SuperactionFor(player : Player, cell : Cell)
	{
		Main.MainConsole.Log("SuperactionForSettle");
		player.Energy += 1;
		player.Energy -= cell.Energy;
		cell.Player = player;
		cell.Update();
	}
}

class PhaseProduce implements Phase
{
	public function new() {}

	public function Go(player : Player) { Main.MainConsole.Log("GoProduce"); }
	
	public function IsValidFor(player : Player, cell : Cell) : Bool
	{
		return (cell.Player == player) && (cell.Production > 0);
	}
	
	public function ActionFor(player : Player, cell : Cell)
	{
		Main.MainConsole.Log("ActionForProduce");
		player.Energy += cell.Production;
		if (cell.Production > 1) cell.Production -= 2; else cell.Production = 0;
		cell.Update();
	}

	public function SuperactionFor(player : Player, cell : Cell)
	{
		Main.MainConsole.Log("SuperactionForProduce");
		player.Energy += cell.Production;
		cell.Production -= 1;
		cell.Update();
	}
}

enum Flow { Init; Select; Explore; Settle; Produce; Upkeep; }

class Rules
{
	public var CurrentPlayer : Player;
	public var Players : Array<Player>;
	public var Phase : String;
	
	var CurrentStep : Flow;
	var CurrentPhase : Phase;
	
	public var ProcessedPlayers : ObjectHash<Player, Bool>;
	public var Process : Void -> Void;
	
	public function new() 
	{
		init();
	}
	
	function init()
	{
		Players = new Array();
		Players.push(new Player(1));
		Players.push(new Player(2));
		Players.push(new Player(3));
		
		ProcessedPlayers = new ObjectHash();
		
		Main.MainGui.Explore.addEventListener(Global.EXPLORE, OnExplore);
		Main.MainGui.Settle .addEventListener(Global.SETTLE,  OnSettle);
		Main.MainGui.Produce.addEventListener(Global.PRODUCE, OnProduce);
		Main.MainGui.Pass   .addEventListener(Global.PASS,    OnPass);
		Main.MainGui.Go     .addEventListener(Global.GO,      OnGo);
		Main.MainGui.Done   .addEventListener(Global.DONE,    OnDone);
	}

	public function start()
	{
		CurrentPlayer = Players[0];
		
		var start = Main.MainBoard.at(Std.random(Main.MainBoard.SizeX), Std.random(Main.MainBoard.SizeY));
		start.Player = CurrentPlayer;
		start.Visible = true;
		start.Update();
		
		for (cell in Main.MainBoard.Cells)
		{
			cell.addEventListener(MouseEvent.CLICK, OnCellClicked);
		}
		
		SetStep(Flow.Init);
		
		UpdatePhase();
		UpdateProcess();
		
		ResetProcessedPlayers(true);
	}
	
	public function SingleLoop()
	{
		if (FinishedProcessingPlayers())
		{
			Main.MainConsole.Log("Moving to next step");
			NextStep();
			
			UpdateProcess();
			
			//UpdateCells();
			
			ResetProcessedPlayers(false);
			Process();
		}
	}
	
	function ResetProcessedPlayers(state : Bool) { for (player in Players) ProcessedPlayers.set(player, state); }
	function FinishedProcessingPlayers() : Bool
	{
		var finished = true;
		for (item in ProcessedPlayers) finished = finished && item;
		return finished;
	}
	function HumanSelect(player : Player) { }
	function HumanExplore(player : Player) { }
	function HumanSettle(player : Player) { }
	function HumanProduce(player : Player) { }
	
	function AISelect(player : Player) { player.Phase = Global.EXPLORE; ProcessedPlayers.set(player, true); }
	function AIExplore(player : Player) { ProcessedPlayers.set(player, true); }
	function AISettle(player : Player) { ProcessedPlayers.set(player, true); }
	function AIProduce(player : Player) { ProcessedPlayers.set(player, true); }
	
	function ProcessNothing()
	{
		ProcessedPlayers.set(Players[0], true);
		ProcessedPlayers.set(Players[1], true);
		ProcessedPlayers.set(Players[2], true);
	}
	
	function ProcessSelect()
	{
		AISelect(Players[2]);
		AISelect(Players[1]);
		
		UpdatePlayer();
		UpdatePhase();
		UpdateCells();
		
		HumanSelect(Players[0]);
	}
	
	function ProcessExplore()
	{
		AIExplore(Players[2]);
		AIExplore(Players[1]);
		
		UpdatePlayer();
		UpdatePhase();
		UpdateCells();
		
		HumanExplore(Players[0]);
	}
	
	function ProcessSettle()
	{
		AISettle(Players[2]);
		AISettle(Players[1]);
		
		UpdatePlayer();
		UpdatePhase();
		UpdateCells();
		
		HumanSettle(Players[0]);
	}
	
	function ProcessProduce()
	{
		AIProduce(Players[2]);
		AIProduce(Players[1]);
		
		UpdatePlayer();
		UpdatePhase();
		UpdateCells();
		
		HumanProduce(Players[0]);
	}
	
	function OnCellClicked(event : MouseEvent)
	{
		if (CurrentPhase.IsValidFor(CurrentPlayer, event.currentTarget))
		{
			if (CurrentPlayer.Phase == Phase)
			{
				CurrentPhase.SuperactionFor(CurrentPlayer, event.currentTarget);
			}
			else
			{
				CurrentPhase.ActionFor(CurrentPlayer, event.currentTarget);
			}
			//UpdatePlayer();
			
			//NextStep();
			//UpdatePhase();
			//CurrentPhase.Go(CurrentPlayer);
			//UpdateCells();
			ProcessedPlayers.set(Players[0], true);
		}
	}
	
	function UpdateCells()
	{
		for (cell in Main.MainBoard.Cells)
		{
			cell.Active = CurrentPhase.IsValidFor(CurrentPlayer, cell);
			cell.Update();
		}
	}
	
	function UpdatePlayer()
	{
		CurrentPlayer.Military = 0;
		CurrentPlayer.Points = 0;
		for (cell in Main.MainBoard.Cells)
		{
			if (cell.Player == CurrentPlayer)
			{
				CurrentPlayer.Military += cell.Military;
				CurrentPlayer.Points += cell.Energy;
			}
		}
	}
	
	function UpdatePhase()
	{
		switch (CurrentStep)
		{
			case Flow.Init:    { Phase = Global.NONE;    CurrentPhase = new PhaseNone(); }
			case Flow.Select:  { Phase = Global.NONE;    CurrentPhase = new PhaseNone(); }
			case Flow.Explore: { Phase = Global.EXPLORE; CurrentPhase = new PhaseExplore(); }
			case Flow.Settle:  { Phase = Global.SETTLE;  CurrentPhase = new PhaseSettle(); }
			case Flow.Produce: { Phase = Global.PRODUCE; CurrentPhase = new PhaseProduce(); }
			case Flow.Upkeep:  { Phase = Global.NONE;    CurrentPhase = new PhaseNone(); }
			default:
		}
	}
	
	function UpdateProcess()
	{
		switch (CurrentStep)
		{
			case Flow.Select:  Process = ProcessSelect;
			case Flow.Explore: Process = ProcessExplore;
			case Flow.Settle:  Process = ProcessSettle;
			case Flow.Produce: Process = ProcessProduce;
			default:           Process = ProcessNothing;
		}
	}
	
	function GetNextStep(step : Flow) : Flow
	{
		switch (step)
		{
			case Flow.Init:    return Flow.Select;
			case Flow.Select:  return Flow.Explore;
			case Flow.Explore: return Flow.Settle;
			case Flow.Settle:  return Flow.Produce;
			case Flow.Produce: return Flow.Upkeep;
			case Flow.Upkeep:  return Flow.Select;
		}
	}
	
	function NextStep()
	{
		SetStep(GetNextStep(CurrentStep));
	}
	
	function SetStep(step : Flow)
	{
		CurrentStep = step;
		switch (step)
		{
			case Flow.Init:
			{
				Main.MainGui.Explore.setActive(false);
				Main.MainGui.Settle.setActive(false);
				Main.MainGui.Produce.setActive(false);
				Main.MainGui.Go.setActive(false);
				Main.MainGui.Pass.setActive(false);
				Main.MainGui.Done.setActive(false);
			}
			
			case Flow.Select:
			{
				Main.MainGui.Explore.setActive(true);
				Main.MainGui.Settle.setActive(true);
				Main.MainGui.Produce.setActive(true);
				Main.MainGui.Go.setActive(false);
				Main.MainGui.Pass.setActive(false);
				Main.MainGui.Done.setActive(false);
			}
			
			case Flow.Explore:
			{
				Main.MainGui.Explore.setActive(false);
				Main.MainGui.Settle.setActive(false);
				Main.MainGui.Produce.setActive(false);
				Main.MainGui.Go.setActive(false);
				Main.MainGui.Pass.setActive(false);
				Main.MainGui.Done.setActive(true);
			}
			
			case Flow.Settle:
			{
				Main.MainGui.Explore.setActive(false);
				Main.MainGui.Settle.setActive(false);
				Main.MainGui.Produce.setActive(false);
				Main.MainGui.Go.setActive(false);
				Main.MainGui.Pass.setActive(false);
				Main.MainGui.Done.setActive(true);
			}
			
			case Flow.Produce:
			{
				Main.MainGui.Explore.setActive(false);
				Main.MainGui.Settle.setActive(false);
				Main.MainGui.Produce.setActive(false);
				Main.MainGui.Go.setActive(false);
				Main.MainGui.Pass.setActive(false);
				Main.MainGui.Done.setActive(true);
			}
			
			case Flow.Upkeep:
			{
				//Phase = Global.NONE;
				CurrentPlayer.Phase = Global.NONE;
				//Main.MainGui.Explore.setActive(false);
				//Main.MainGui.Settle.setActive(false);
				//Main.MainGui.Produce.setActive(false);
				//Main.MainGui.Go.setActive(false);
				//Main.MainGui.Pass.setActive(true);
				NextStep();
			}
		}
	}
	
	function OnExplore(event : Event)
	{
		Main.MainConsole.Log("OnExplore");
		CurrentPlayer.Phase = Global.EXPLORE;
		Main.MainGui.Done.setActive(true);
	}
	
	function OnSettle(event : Event)
	{
		Main.MainConsole.Log("OnSettle");
		CurrentPlayer.Phase = Global.SETTLE;
		Main.MainGui.Done.setActive(true);
	}
	
	function OnProduce(event : Event)
	{
		Main.MainConsole.Log("OnProduce");
		CurrentPlayer.Phase = Global.PRODUCE;
		Main.MainGui.Done.setActive(true);
	}
	
	function OnGo(event : Event)
	{
		Main.MainConsole.Log("OnGo");
		ProcessedPlayers.set(Players[0], true);
		//NextStep();
		//UpdatePhase();
		//CurrentPhase.Go(CurrentPlayer);
		//UpdateCells();
	}
	
	function OnPass(event : Event)
	{
		Main.MainConsole.Log("OnPass");
		ProcessedPlayers.set(Players[0], true);
		//NextStep();
		//UpdatePhase();
		//CurrentPhase.Go(CurrentPlayer);
		//UpdateCells();
	}
	
	function OnDone(event : Event)
	{
		Main.MainConsole.Log("OnDone");
		ProcessedPlayers.set(Players[0], true);
	}
	
}