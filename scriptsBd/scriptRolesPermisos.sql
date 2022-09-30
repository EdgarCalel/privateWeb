create table roles
(
    id serial primary key,
    name varchar(255) not null,
    guard_name varchar(255) not null,
    created_at timestamp    null,
    updated_at timestamp    null,
    constraint roles_name_guard_name_unique
        unique (name, guard_name)
);

create table permissions
(
    id  serial primary key,
    name varchar(255) not null,
    guard_name varchar(255) not null,
    created_at timestamp    null,
    updated_at timestamp    null,
    constraint permissions_name_guard_name_unique
        unique (name, guard_name)
);

create table model_has_roles
(
    role_id    integer  not null,
    model_type varchar(255)    not null,
    model_id   integer  not null,
    primary key (role_id, model_id, model_type),
    constraint model_has_roles_role_id_foreign
        foreign key (role_id) references roles (id)
            on delete cascade
);


create index model_has_roles_model_id_model_type_index
    on model_has_roles (model_id, model_type);

create table model_has_permissions
(
    permission_id integer  not null,
    model_type    varchar(255)    not null,
    model_id      integer  not null,
    primary key (permission_id, model_id, model_type),
    constraint model_has_permissions_permission_id_foreign
        foreign key (permission_id) references permissions (id)
            on delete cascade
);

create index model_has_permissions_model_id_model_type_index
    on model_has_permissions (model_id, model_type);

create table role_has_permissions
(
    permission_id integer  not null,
    role_id       integer  not null,
    primary key (permission_id, role_id),
    constraint role_has_permissions_permission_id_foreign
        foreign key (permission_id) references permissions (id)
            on delete cascade,
    constraint role_has_permissions_role_id_foreign
        foreign key (role_id) references roles (id)
            on delete cascade
);