<table class="chrno-table">
  <thead class="chrno-table-head">
    <tr>
      <th><%%= t ".created_at" %></th>
      <th><%%= t ".author" %></th>
      <th><%%= t ".action" %></th>
      <th><%%= t ".diff" %></th>
      <th><%%= t ".context" %></th>
    </tr>
  </thead>

  <tbody class="chrno-table-body">
    <%% @<%= plural_name %>.each do |item| %>
      <tr>
        <td><%%= l item.created_at, format: :short %></td>
        <td><%%= item.initiator.try :name || item.initiator.to_s %></td>
        <td><%%= item.action %></td>
        <td>
          <dl class="diff">
            <%% item.diff.each do |attr, ( old_value, new_value )| %>
              <dt>
                <%%= item.auditable.class.human_attribute_name( attr ) %>
              </dt>
              <dd>
                <del>
                  <%%= old_value.inspect %>
                </del>
                <ins>
                  <%%= new_value.inspect %>
                </ins>
              </dd>
            <%% end %>
          </dl>
        </td>
        <td>
          <ul>
            <%% item.context.each do |key, value| %>
              <li>
                <strong><%%= key %>:&nbsp;</strong><%%= value %>
              </li>
            <%% end %>
          </ul>
        </td>
      </tr>
    <%% end %>
  </tbody>

  <tfoot>
    <tr>
      <td colspan="5"><%%= paginate @<%= plural_name %> %></td>
    </tr>
  </tfoot>
</table>
