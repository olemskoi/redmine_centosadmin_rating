class RatingQuery < Query
  self.queried_class = Rating

  self.available_columns = [
    QueryColumn.new(:project, sortable: "#{Project.table_name}.name", groupable: true),
    QueryColumn.new(:evaluator, sortable: lambda{ User.fields_for_order_statement }, groupable: true),
    QueryColumn.new(:evaluated, sortable: lambda{ User.fields_for_order_statement }, groupable: true),
    QueryColumn.new(:mark, sortable: "#{Rating.table_name}.mark", groupable: true),
    QueryColumn.new(:comments),
    QueryColumn.new(:created_on, sortable: "#{Rating.table_name}.created_on", default_order: 'desc', groupable: true)
  ]

  def initialize(attributes=nil, *args)
    super attributes
    self.filters ||= {}
    add_filter('created_on', '*') unless filters.present?
  end

  def initialize_available_filters
    add_available_filter 'created_on', type: :date_past
    add_available_filter 'mark', type: :list, values: (1..3).to_a
    add_available_filter 'comments', type: :text

    principals = []
    if project
      principals += project.principals.sort
      unless project.leaf?
        subprojects = project.descendants.visible.all
        if subprojects.any?
          add_available_filter "subproject_id",
            :type => :list_subprojects,
            :values => subprojects.collect{|s| [s.name, s.id.to_s] }
          principals += Principal.member_of(subprojects)
        end
      end
    else
      if all_projects.any?
        principals += Principal.member_of all_projects
        project_values = []
        if User.current.logged? && User.current.memberships.any?
          project_values << ["<< #{l(:label_my_projects).downcase} >>", "mine"]
        end
        project_values += all_projects_values
        add_available_filter("project_id",
          :type => :list, :values => project_values
        ) unless project_values.empty?
      end
    end
    principals.uniq!
    principals.sort!
    users = principals.select {|p| p.is_a?(User)}

    users_values = []
    users_values << ["<< #{l(:label_me)} >>", "me"] if User.current.logged?
    users_values += users.collect{|s| [s.name, s.id.to_s] }

    unless users_values.empty?
      add_available_filter 'evaluator_id', type: :list_optional, values: users_values
      add_available_filter 'evaluated_id', type: :list_optional, values: users_values
    end
  end

  def available_columns
    return @available_columns if @available_columns
    @available_columns = self.class.available_columns.dup
  end

  def default_columns_names
    @default_columns_names ||= [:project, :evaluator, :evaluated, :mark, :comments]
  end

  def results_scope(options={})
    order_option = [group_by_sort_order, options[:order]].flatten.reject(&:blank?)

    Rating.
      where(statement).
      order(order_option).
      joins(joins_for_order_statement(order_option.join(',')))
  end
end
