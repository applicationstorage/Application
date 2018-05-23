class CategoriesController < ApplicationController

  # for each category list the items associated to that category
  # regardless of amount in stock
  
  def departmental_devices
    @dept_devices = Inventory.where(:item_category => 'Departmental Devices').order('item_name DESC')
  end

  def laptops
    @laptops = Inventory.where(:item_category => 'Laptops').order('item_name DESC')
  end

  def tablets
    @tablets = Inventory.where(:item_category => 'Tablets').order('item_name DESC')
  end

  def cameras_recorders
    @cams_recs = Inventory.where(:item_category => 'Cameras & Recorders').order('item_name DESC')
  end

  def audio_devices
    @audio_devices = Inventory.where(:item_category => 'Audio Devices').order('item_name DESC')
  end

  def misc_devices
    @miscs = Inventory.where(:item_category => 'Misc. Devices').order('item_name DESC')
  end

end
