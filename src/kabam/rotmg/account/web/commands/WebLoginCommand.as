﻿//kabam.rotmg.account.web.commands.WebLoginCommand

package kabam.rotmg.account.web.commands
{
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;

import flash.display.Sprite;

import kabam.lib.tasks.BranchingTask;
import kabam.lib.tasks.DispatchSignalTask;
import kabam.lib.tasks.TaskMonitor;
import kabam.lib.tasks.TaskSequence;
import kabam.rotmg.account.core.services.LoginTask;
import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
import kabam.rotmg.account.web.model.AccountData;
import kabam.rotmg.core.model.ScreenModel;
import kabam.rotmg.core.service.TrackingData;
import kabam.rotmg.core.signals.InvalidateDataSignal;
import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
import kabam.rotmg.core.signals.TaskErrorSignal;
import kabam.rotmg.core.signals.TrackEventSignal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.mysterybox.services.GetMysteryBoxesTask;
import kabam.rotmg.packages.services.GetPackagesTask;

public class WebLoginCommand
{

	[Inject]
	public var data:AccountData;
	[Inject]
	public var loginTask:LoginTask;
	[Inject]
	public var monitor:TaskMonitor;
	[Inject]
	public var closeDialogs:CloseDialogsSignal;
	[Inject]
	public var loginError:TaskErrorSignal;
	[Inject]
	public var updateLogin:UpdateAccountInfoSignal;
	[Inject]
	public var track:TrackEventSignal;
	[Inject]
	public var invalidate:InvalidateDataSignal;
	[Inject]
	public var setScreenWithValidData:SetScreenWithValidDataSignal;
	[Inject]
	public var screenModel:ScreenModel;
	[Inject]
	public var getPackageTask:GetPackagesTask;
	[Inject]
	public var mysteryBoxTask:GetMysteryBoxesTask;
	private var setScreenTask:DispatchSignalTask;


	public function execute():void
	{
		this.setScreenTask = new DispatchSignalTask(this.setScreenWithValidData, this.getTargetScreen());
		var _local_1:BranchingTask = new BranchingTask(this.loginTask, this.makeSuccessTask(), this.makeFailureTask());
		this.monitor.add(_local_1);
		_local_1.start();
	}

	private function makeSuccessTask():TaskSequence
	{
		Parameters.Cache_CHARLIST_valid = false;
		var _local_1:TaskSequence;
		_local_1 = new TaskSequence();
		_local_1.add(new DispatchSignalTask(this.closeDialogs));
		_local_1.add(new DispatchSignalTask(this.updateLogin));
		_local_1.add(new DispatchSignalTask(this.invalidate));
		//_local_1.add(this.getPackageTask); TODO need this?
		//_local_1.add(this.mysteryBoxTask);
		_local_1.add(this.setScreenTask);
		return (_local_1);
	}

	private function makeFailureTask():TaskSequence
	{
		Parameters.Cache_CHARLIST_valid = false;
		var _local_1:TaskSequence = new TaskSequence();
		_local_1.add(new DispatchSignalTask(this.loginError, this.loginTask));
		_local_1.add(this.setScreenTask);
		return (_local_1);
	}

	private function getTargetScreen():Sprite
	{
		var _local_1:Class = this.screenModel.getCurrentScreenType();
		if (((_local_1 == null) || (_local_1 == GameSprite)))
		{
			_local_1 = CharacterSelectionAndNewsScreen;
		}
		return (new (_local_1)());
	}

	private function getTrackingData():TrackingData
	{
		var _local_1:TrackingData = new TrackingData();
		_local_1.category = "account";
		_local_1.action = "signedIn";
		return (_local_1);
	}


}
}//package kabam.rotmg.account.web.commands

