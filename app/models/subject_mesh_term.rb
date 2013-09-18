class SubjectMeshTerm < ActiveRecord::Base
  has_many :mesh_trees, :foreign_key => "term_id"

  attr_accessor :term_id, :term

  def self.from_tree_number(tree_id)
    SubjectMeshTerm.joins(:mesh_trees).where('mesh_trees.tree_number = ?', tree_id)
  end

  def trees
    MeshTree.where(term_id: self.term_id).map { |t| t.tree_number }
  end

  def synonyms
    s = read_attribute(:synonyms)
    s.nil? ? [] : s.split("|")
  end

  def synonyms=(syn_list)
    write_attribute(:synonyms,
                    if syn_list.respond_to?(:join)
                      syn_list.join('|')
                    else
                      syn_list
                    end)
  end
end
