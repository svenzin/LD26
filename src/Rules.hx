package ;
import nme.events.Event;
import nme.events.MouseEvent;

/**
 * ...
 * @author scorder
 */
interface Phase
{
	function Go(player : Player) : Void;
	function IsValidFor(player : Player, cell : Cell) : Bool;
	function ActionFor(player : Player, cell : Cell) : Void;
}

class PhaseNone implements Phase
{
	public function new() {}
	public function Go(player : Player) { Main.MainConsole.Log("GoNone"); }
	public function IsValidFor(player : Player, cell : Cell) : Bool { return true; }
	public function ActionFor(player : Player, cell : Cell) { Main.MainConsole.Log("ActionForNone"); }
}

class PhaseExplore implements Phase
{
	public function new() {}

	public function Go(player : Player)
	{
		Main.MainConsole.Log("GoExplore");
		player.Energy += 1;
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
		cell.Production -= 1;
		cell.Update();
	}
}

enum Flow { Select; Explore; Settle; Produce;  Upkeep; }

class Rules
{
	public var Nobody : Player;
	public var CurrentPlayer : Player;
	public var Players : Array<Player>;
	public var Phase : String;
	
	var CurrentStep : Flow;
	var CurrentPhase : Phase;
	
	public function new() 
	{
		init();
	}
	
	function init()
	{
		SetStep(Flow.Select);
		UpdatePhase();
		
		Players = new Array();
		Players.push(new Player(1));
		Players.push(new Player(2));
		Players.push(new Player(3));
		
		CurrentPlayer = Players[0];
		
		Main.MainGui.Explore.addEventListener(Global.EXPLORE, OnExplore);
		Main.MainGui.Settle .addEventListener(Global.SETTLE,  OnSettle);
		Main.MainGui.Produce.addEventListener(Global.PRODUCE, OnProduce);
		Main.MainGui.Pass   .addEventListener(Global.PASS,    OnPass);
		Main.MainGui.Go     .addEventListener(Global.GO,      OnGo);
	}

	public function start()
	{
		var start = Main.MainBoard.at(Std.random(Main.MainBoard.SizeX), Std.random(Main.MainBoard.SizeY));
		start.Player = CurrentPlayer;
		start.Visible = true;
		start.Update();
		
		for (cell in Main.MainBoard.Cells)
		{
			cell.addEventListener(MouseEvent.CLICK, OnCellClicked);
		}
	}
	
	function OnCellClicked(event : MouseEvent)
	{
		if (CurrentPhase.IsValidFor(CurrentPlayer, event.currentTarget))
		{
			CurrentPhase.ActionFor(CurrentPlayer, event.currentTarget);
			UpdatePlayer();
			
			NextStep();
			UpdatePhase();
			CurrentPhase.Go(CurrentPlayer);
			UpdateCells();
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
			case Flow.Select:  CurrentPhase = new PhaseNone();
			case Flow.Explore: CurrentPhase = new PhaseExplore();
			case Flow.Settle:  CurrentPhase = new PhaseSettle();
			case Flow.Produce: CurrentPhase = new PhaseProduce();
			case Flow.Upkeep:  CurrentPhase = new PhaseNone();
			default:
		}
	}
	
	function NextStep()
	{
		switch (CurrentStep)
		{
			case Flow.Select:  SetStep(Flow.Explore);
			case Flow.Explore: SetStep(Flow.Settle);
			case Flow.Settle:  SetStep(Flow.Produce);
			case Flow.Produce: SetStep(Flow.Upkeep);
			case Flow.Upkeep:  SetStep(Flow.Select);
		}
	}
	
	function SetStep(step : Flow)
	{
		CurrentStep = step;
		switch (step)
		{
			case Flow.Select:
			{
				Phase = Global.NONE;
				Main.MainGui.Explore.setActive(true);
				Main.MainGui.Settle.setActive(true);
				Main.MainGui.Go.setActive(false);
				Main.MainGui.Pass.setActive(false);
			}
			
			case Flow.Explore:
			{
				Phase = Global.EXPLORE;
				Main.MainGui.Explore.setActive(false);
				Main.MainGui.Settle.setActive(false);
				Main.MainGui.Go.setActive(false);
				Main.MainGui.Pass.setActive(true);
			}
			
			case Flow.Settle:
			{
				Phase = Global.SETTLE;
				Main.MainGui.Explore.setActive(false);
				Main.MainGui.Settle.setActive(false);
				Main.MainGui.Go.setActive(false);
				Main.MainGui.Pass.setActive(true);
			}
			
			case Flow.Produce:
			{
				
			}
			
			case Flow.Upkeep:
			{
				Phase = Global.NONE;
				CurrentPlayer.Phase = Global.NONE;
				Main.MainGui.Explore.setActive(false);
				Main.MainGui.Settle.setActive(false);
				Main.MainGui.Go.setActive(false);
				Main.MainGui.Pass.setActive(true);
				NextStep();
			}
		}
	}
	
	function OnExplore(event : Event)
	{
		Main.MainConsole.Log("OnExplore");
		CurrentPlayer.Phase = Global.EXPLORE;
		Main.MainGui.Go.setActive(true);
	}
	
	function OnSettle(event : Event)
	{
		Main.MainConsole.Log("OnSettle");
		CurrentPlayer.Phase = Global.SETTLE;
		Main.MainGui.Go.setActive(true);
	}
	
	function OnProduce(event : Event)
	{
		Main.MainConsole.Log("OnProduce");
		CurrentPlayer.Phase = Global.PRODUCE;
		Main.MainGui.Go.setActive(true);
	}
	
	function OnGo(event : Event)
	{
		Main.MainConsole.Log("OnGo");
		NextStep();
		UpdatePhase();
		CurrentPhase.Go(CurrentPlayer);
		UpdateCells();
	}
	
	function OnPass(event : Event)
	{
		Main.MainConsole.Log("OnPass");
		NextStep();
		UpdatePhase();
		CurrentPhase.Go(CurrentPlayer);
		UpdateCells();
	}
	
}