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
	function Cost() : Int;
}

class PhaseNone implements Phase
{
	public function new() {}
	public function Go(player : Player) { Main.MainConsole.Log("GoNone"); }
	public function IsValidFor(player : Player, cell : Cell) : Bool { return false; }
	public function ActionFor(player : Player, cell : Cell) { Main.MainConsole.Log("ActionForNone"); }
	public function Cost() : Int { return 0; }
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
		cell.Visible.Add(player);
		for (other in Main.MainBoard.neighbours(cell))
		{
			other.Visible.Add(player);
		}
	}
	
	public function Cost() : Int { return 1; }
}

class PhaseSettle implements Phase
{
	public function new() {}

	public function Go(player : Player) { Main.MainConsole.Log("GoSettle"); }
	
	public function IsValidFor(player : Player, cell : Cell) : Bool
	{
		if (cell.Player == player) return false;
		if (cell.Energy + cell.Production > player.Energy) return false;
		if (!cell.Visible.Check(player)) return false;
		
		for (other in Main.MainBoard.neighbours(cell))
		{
			if (other.Player == player) return true;
		}
		
		return false;
	}
	
	public function ActionFor(player : Player, cell : Cell)
	{
		Main.MainConsole.Log("ActionForSettle");
		player.Spending -= cell.Energy;
		cell.Player = player;
	}
	
	public function Cost() : Int { return 1; }
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
		player.Spending += cell.Production;
	}
	
	public function Cost() { return 0; }
}

class PhaseUpkeep implements Phase
{
	public function new() {}

	public function Go(player : Player) { Main.MainConsole.Log("GoUpkeep"); }
	
	public function IsValidFor(player : Player, cell : Cell) : Bool
	{
		if (cell.Player != player) return false;
		
		if (player.Spending > 0) return cell.Energy < Global.MAX_ENERGY;
		if (player.Spending < 0) return cell.Energy > 0;
		
		return false;
	}
	
	public function ActionFor(player : Player, cell : Cell)
	{
		Main.MainConsole.Log("ActionForProduce");
		if (player.Spending > 0)
		{
			cell.Energy += 1;
			player.Spending -= 1;
		}
		else if (player.Spending < 0)
		{
			cell.Energy -= 1;
			player.Spending += 1;
		}
	}
	
	public function Cost() { return 0; }
}

enum Flow { Init; Select; Explore; Settle; Produce; Upkeep; }

class Rules
{
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
	}

	public function start()
	{
		var start : Cell;
		
		start = Main.MainBoard.at(Std.random(Main.MainBoard.SizeX), Std.random(Main.MainBoard.SizeY));
		start.Player = Players[0];
		start.Energy = 2;
		start.Production = 2;
		start.Visible.Add(Players[0]);
		
		while (start.Player == Players[0])
		{
			start = Main.MainBoard.at(Std.random(Main.MainBoard.SizeX), Std.random(Main.MainBoard.SizeY));
		}
		start.Player = Players[1];
		start.Energy = 2;
		start.Production = 2;
		start.Visible.Add(Players[1]);
		
		while (start.Player == Players[0] || start.Player == Players[1])
		{
			start = Main.MainBoard.at(Std.random(Main.MainBoard.SizeX), Std.random(Main.MainBoard.SizeY));
		}
		start.Player = Players[2];
		start.Energy = 2;
		start.Production = 2;
		start.Visible.Add(Players[2]);

		for (cell in Main.MainBoard.Cells)
		{
			cell.addEventListener(MouseEvent.CLICK, OnCellClicked);
		}
		
		SetStep(Flow.Init);
		
		UpdatePlayers();
		UpdateCells();
		UpdateProcess();
		
		ResetProcessedPlayers(true);
	}
	
	public function SingleLoop()
	{
		if (FinishedProcessingPlayers())
		{
			//Main.MainConsole.Log("Moving to next step");
			NextStep();
			
			UpdateProcess();
			
			if (CurrentStep == Flow.Upkeep) DetectEndGame();
			if (CurrentStep == Flow.Upkeep) PostProcess();
			
			ResetProcessedPlayers(false);
			Process();
		}
	}
	
	function PostProcess()
	{
		for (cell in Main.MainBoard.Cells)
		{
			if (cell.Energy > Global.MAX_STABLE_ENERGY) cell.Energy -= 1;
		}
	}
	
	function IsDead(player : Player) : Bool { return player.Spending + player.Energy < 0;  }
	function DetectEndGame()
	{
		if (IsDead(Players[0]))
		{
			
		}
		if (IsDead(Players[1]) && IsDead(Players[2]))
		{
			
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
	function HumanDevelop(player : Player) { }
	function HumanSettle(player : Player) { }
	function HumanProduce(player : Player) { }
	function HumanUpkeep(player : Player)
	{
		player.Phase = Global.NONE;
		if (player.Spending == 0) ProcessedPlayers.set(player, true);
	}
	
	function RandomAISelect(player : Player)
	{
		switch (Std.random(3))
		{
			case 0: player.Phase = Global.EXPLORE;
			case 1: player.Phase = Global.SETTLE;
			case 2: player.Phase = Global.PRODUCE;
		}
		ProcessedPlayers.set(player, true);
	}
	function RandomAIExplore(player : Player)
	{
		var candidates : Array<Cell> = new Array();
		for (cell in Main.MainBoard.Cells)
		{
			if (CurrentPhase.IsValidFor(player, cell) && !cell.Visible.Check(player)) candidates.push(cell);
		}
		if (candidates.length > 0) ExecuteAction(player, candidates[Std.random(candidates.length)]);
		ProcessedPlayers.set(player, true);
	}
	function RandomAISettle(player : Player)
	{
		var candidates : Array<Cell> = new Array();
		for (cell in Main.MainBoard.Cells)
		{
			if (CurrentPhase.IsValidFor(player, cell)) candidates.push(cell);
		}
		if (candidates.length > 0) ExecuteAction(player, candidates[Std.random(candidates.length)]);
		ProcessedPlayers.set(player, true);
	}
	function RandomAIProduce(player : Player)
	{
		var candidates : Array<Cell> = new Array();
		for (cell in Main.MainBoard.Cells)
		{
			if (CurrentPhase.IsValidFor(player, cell)) candidates.push(cell);
		}
		if (candidates.length > 0) ExecuteAction(player, candidates[Std.random(candidates.length)]);
		ProcessedPlayers.set(player, true);
	}
	function RandomAIUpkeep(player : Player)
	{
		player.Phase = Global.NONE;
		ProcessedPlayers.set(player, true);
		
		if (player.Spending + player.Energy < 0) { player.Energy = -10; return; }
		
		while (player.Spending != 0)
		{
			var candidates : Array<Cell> = new Array();
			for (cell in Main.MainBoard.Cells)
			{
				if (CurrentPhase.IsValidFor(player, cell)) candidates.push(cell);
			}
			if (candidates.length > 0) ExecuteAction(player, candidates[Std.random(candidates.length)]);
			else player.Spending = 0;
		}
	}
	
	function ProcessNothing()
	{
		UpdatePlayers();
		UpdateCells();
		
		ProcessedPlayers.set(Players[0], true);
		ProcessedPlayers.set(Players[1], true);
		ProcessedPlayers.set(Players[2], true);
	}
	
	function ProcessSelect()
	{
		UpdatePlayers();
		UpdateCells();
		
		RandomAISelect(Players[2]);
		RandomAISelect(Players[1]);
		HumanSelect(Players[0]);
	}
	
	function ProcessExplore()
	{
		UpdatePlayers();
		UpdateCells();
		
		if (Players[2].Phase == Global.EXPLORE) RandomAIExplore(Players[2]);    else ProcessedPlayers.set(Players[2], true);
		if (Players[1].Phase == Global.EXPLORE) RandomAIExplore(Players[1]);    else ProcessedPlayers.set(Players[1], true);
		if (Players[0].Phase == Global.EXPLORE) HumanExplore(Players[0]); else ProcessedPlayers.set(Players[0], true);
	}
	
	function ProcessSettle()
	{
		UpdatePlayers();
		UpdateCells();
		
		if (Players[2].Phase == Global.SETTLE) RandomAISettle(Players[2]);    else ProcessedPlayers.set(Players[2], true);
		if (Players[1].Phase == Global.SETTLE) RandomAISettle(Players[1]);    else ProcessedPlayers.set(Players[1], true);
		if (Players[0].Phase == Global.SETTLE) HumanSettle(Players[0]); else ProcessedPlayers.set(Players[0], true);
	}
	
	function ProcessProduce()
	{
		UpdatePlayers();
		UpdateCells();
		
		if (Players[2].Phase == Global.PRODUCE) RandomAIProduce(Players[2]);    else ProcessedPlayers.set(Players[2], true);
		if (Players[1].Phase == Global.PRODUCE) RandomAIProduce(Players[1]);    else ProcessedPlayers.set(Players[1], true);
		if (Players[0].Phase == Global.PRODUCE) HumanProduce(Players[0]); else ProcessedPlayers.set(Players[0], true);
	}
	
	function ProcessUpkeep()
	{
		UpdatePlayers();
		UpdateCells();
		
		RandomAIUpkeep(Players[2]);
		RandomAIUpkeep(Players[1]);
		HumanUpkeep(Players[0]);
	}
	
	function ExecuteAction(player : Player, cell : Cell)
	{
		player.Spending -= CurrentPhase.Cost();
		CurrentPhase.ActionFor(player, cell);
		
		if (CurrentStep == Flow.Upkeep)
		{
			if (player.Spending == 0) ProcessedPlayers.set(player, true);
		}
		else
		{
			ProcessedPlayers.set(player, true);
		}

		UpdatePlayers();
		UpdateCells();
	}
	
	function OnCellClicked(event : MouseEvent)
	{
		if (CurrentPhase.IsValidFor(Players[0], event.currentTarget))
		{
			ExecuteAction(Players[0], event.currentTarget);
		}
	}
	
	function UpdateCells()
	{
		for (cell in Main.MainBoard.Cells)
		{
			cell.Active = CurrentPhase.IsValidFor(Players[0], cell);
			cell.Update(Players[0]);
		}
	}
	
	function UpdatePlayers()
	{
		for (player in Players)
		{
			player.Energy = 0;
			player.Production = 0;
			for (cell in Main.MainBoard.Cells)
			{
				if (cell.Player == player)
				{
					player.Energy += cell.Energy;
					player.Production += cell.Production;
				}
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
			case Flow.Upkeep:  { Phase = Global.UPKEEP;  CurrentPhase = new PhaseUpkeep(); }
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
			case Flow.Upkeep:  Process = ProcessUpkeep;
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
		
		UpdatePhase();
		
		switch (step)
		{
			case Flow.Init:
			{
				Main.MainGui.Explore.setActive(false);
				Main.MainGui.Settle .setActive(false);
				Main.MainGui.Produce.setActive(false);
				Main.MainGui.Upkeep .setActive(false);
				Main.MainGui.Pass   .setActive(false);
			}
			
			case Flow.Select:
			{
				Main.MainGui.Explore.setActive(Players[0].Energy >= new PhaseExplore().Cost());
				Main.MainGui.Settle .setActive(Players[0].Energy >= new PhaseSettle().Cost());
				Main.MainGui.Produce.setActive(Players[0].Energy >= new PhaseProduce().Cost());
				Main.MainGui.Upkeep.setActive(false);
				Main.MainGui.Pass  .setActive(false);
			}
			
			case Flow.Explore:
			{
				Main.MainGui.Explore.setActive(false);
				Main.MainGui.Settle .setActive(false);
				Main.MainGui.Produce.setActive(false);
				Main.MainGui.Upkeep .setActive(false);
				Main.MainGui.Pass   .setActive(true);
			}
			
			case Flow.Settle:
			{
				Main.MainGui.Explore.setActive(false);
				Main.MainGui.Settle .setActive(false);
				Main.MainGui.Produce.setActive(false);
				Main.MainGui.Upkeep .setActive(false);
				Main.MainGui.Pass   .setActive(true);
			}
			
			case Flow.Produce:
			{
				Main.MainGui.Explore.setActive(false);
				Main.MainGui.Settle .setActive(false);
				Main.MainGui.Produce.setActive(false);
				Main.MainGui.Upkeep .setActive(false);
				Main.MainGui.Pass   .setActive(true);
			}
			
			case Flow.Upkeep:
			{
				Main.MainGui.Explore.setActive(false);
				Main.MainGui.Settle .setActive(false);
				Main.MainGui.Produce.setActive(false);
				Main.MainGui.Upkeep .setActive(true);
				Main.MainGui.Pass   .setActive(Players[0].Spending > 0);
			}
		}
	}
	
	function OnExplore(event : Event)
	{
		Main.MainConsole.Log("OnExplore");
		Players[0].Phase = Global.EXPLORE;
		//Main.MainGui.Done.setActive(true);
		ProcessedPlayers.set(Players[0], true);
	}
	
	function OnSettle(event : Event)
	{
		Main.MainConsole.Log("OnSettle");
		Players[0].Phase = Global.SETTLE;
		//Main.MainGui.Done.setActive(true);
		ProcessedPlayers.set(Players[0], true);
	}
	
	function OnProduce(event : Event)
	{
		Main.MainConsole.Log("OnProduce");
		Players[0].Phase = Global.PRODUCE;
		//Main.MainGui.Done.setActive(true);
		ProcessedPlayers.set(Players[0], true);
	}
	
	function OnPass(event : Event)
	{
		Main.MainConsole.Log("OnPass");
		if (CurrentStep == Flow.Upkeep) Players[0].Spending = 0;
		ProcessedPlayers.set(Players[0], true);
	}
	
}